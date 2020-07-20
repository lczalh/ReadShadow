//
//  CZNetwork.swift
//  Random
//
//  Created by yu mingming on 2019/11/29.
//  Copyright © 2019 刘超正. All rights reserved.
//

import Foundation

struct CZError: Error {
    var message: String = ""
    
    var localizedDescription: String {
        return self.message
    }
    
    init(_ message: String) {
        self.message = message
    }
}

struct CZNetwork {
    static let cz_provider = MoyaProvider<MultiTarget>(endpointClosure: endpointMapping,
                                                        requestClosure: timeoutClosure,
                                                        plugins: [RequestHudPlugin, RequestAlertPlugin()])
    
    /// 网络请求&重用机制
    /// - Parameters:
    ///   - target: target description
    ///   - model: model description
    ///   - delay: delay description
    ///   - max: max description
    ///   - callbackQueue: callbackQueue description
    ///   - progress: progress description
    ///   - completion: completion description
    static func cz_request<T: BaseMappable>(target: TargetType,
                                            model: T.Type,
                                            delay: Double = 3,
                                            max: Int = 3,
                                            callbackQueue: DispatchQueue? = .none,
                                            progress: ProgressBlock? = .none,
                                            completion: @escaping (_ result: Result<T, CZError>) -> Void) {
        guard CZCommon.cz_isProxyDetection() == true else {
            completion(.failure(CZError("检测到非法网络代理，请关闭后重试！！！")))
            return
        }
        cz_provider.request(MultiTarget(target), callbackQueue: callbackQueue, progress: progress) { (result) in
            switch result {
            case let .success(response):
                do {
                    let response = try response.filterSuccessfulStatusCodes()
                    do {
                        let jsonDict = try response.mapJSON() as? Dictionary<String, Any>
                        cz_print(jsonDict?.jsonString() as Any)
                        if let model = Mapper<T>(context: nil).map(JSONObject: jsonDict) {
                            completion(.success(model))
                        } else {
                            completion(.failure(CZError("数据解析失败")))
                        }
                    } catch {
                        completion(.failure(CZError("json格式有误")))
                    }
                } catch {
                    completion(.failure(CZError("数据获取失败")))
                }
            case .failure(_):
                if max == 1 {
                    completion(.failure(CZError("似乎已断开与互联网的连接")))
                } else { // 重试
                    DispatchQueue(label: "com.request.queue", attributes: .concurrent).asyncAfter(deadline: DispatchTime.now() + delay) {
                        cz_request(target: target, model: model, delay: delay, max: max - 1, completion: completion)
                    }
                }
            }
        }
    }
    
    /// 网络请求&重用机制(RxSwift)
    /// - Parameters:
    ///   - target: target description
    ///   - model: model description
    ///   - delay: delay description
    ///   - max: max description
    ///   - callbackQueue: callbackQueue description
    ///   - progress: progress description
    static func cz_request<T: BaseMappable>(target: TargetType,
                                            model: T.Type,
                                            delay: Double = 3,
                                            max: Int = 3,
                                            callbackQueue: DispatchQueue? = .none,
                                            progress: ProgressBlock? = .none) -> Single<T>  {
        return Single.create { single in
            let cancellableToken = cz_provider.request(MultiTarget(target), callbackQueue: callbackQueue, progress: progress) { result in
                switch result {
                case let .success(response):
                    do {
                        let response = try response.filterSuccessfulStatusCodes()
                        do {
                            let jsonDict = try response.mapJSON() as? Dictionary<String, Any>
                            cz_print(jsonDict?.jsonString() as Any)
                            if let model = Mapper<T>(context: nil).map(JSONObject: jsonDict) {
                                single(.success(model))
                            } else {
                                single(.error(CZError("数据解析失败")))
                            }
                        } catch {
                            single(.error(CZError("json格式有误")))
                        }
                    } catch {
                        single(.error(CZError("数据获取失败")))
                    }
                case .failure(_):
                    single(.error(CZError("似乎已断开与互联网的连接")))
                }
            }
            return Disposables.create {
                cancellableToken.cancel()
            }
        }.retryWhen(retryHandler(delay: Int(delay),max: max))
        
    }
}

/// 设置接口的超时时间
public let timeoutClosure = { (endpoint: Endpoint, closure: MoyaProvider<MultiTarget>.RequestResultClosure) -> Void in
    if var urlRequest = try? endpoint.urlRequest() {
        urlRequest.timeoutInterval = 5
        closure(.success(urlRequest))
    }
    else{
        closure(.failure(MoyaError.requestMapping(endpoint.url)))
    }
}


/// 管理网络状态的插件
public let RequestHudPlugin = NetworkActivityPlugin { change, target  in
    switch change {
    case .began:
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
    case .ended:
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
}

/// 打印请求地址，路径，参数
///
/// - Parameter target: target description
/// - Returns: return value description
public func endpointMapping(target: MultiTarget) -> Endpoint {
    cz_print(target.baseURL, target.path, target.task)
    return MoyaProvider.defaultEndpointMapping(for: target)
}


/// 自定义插件
final class RequestAlertPlugin: PluginType {
    
    /// 开始发起请求。我们可以在这里显示网络状态指示器。
    func willSend(_ request: RequestType, target: TargetType) {
        cz_print("开始发起网络请求")
    }
    
    /// 收到请求响应。我们可以在这里根据结果自动进行一些处理，比如请求失败时将失败信息告诉用户，或者记录到日志中。
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        switch result {
        case .success(let response):
            guard let jsonDict = try? response.mapJSON() as? Dictionary<String, Any> else {
                return
            }
            cz_print(jsonDict)
            break
        case .failure(let error):
            cz_print(error)
            break
        }
    }
    
    /// 处理请求结果。我们可以在 completion 前对结果进行进一步处理。
    func process(_ result: Result<Response, MoyaError>, target: TargetType) -> Result<Response, MoyaError> {
        cz_print("处理网络请求结果")
        
        return result
    }
    
    /// 准备发起请求。我们可以在这里对请求进行修改，比如再增加一些额外的参数。
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        cz_print("准备发起网络请求")
        return request
    }
}

/// 重试机制
/// - Parameter delay: 每几秒重试
/// - Parameter max: 最大重试次数
public func retryHandler(delay: Int = 5, max: Int = 5) -> ((Observable<Error>) -> Observable<Int>) {
    return { error in
        return error.enumerated().flatMap { (index, error) -> Observable<Int> in
            guard index < max else {
                return Observable.error(error)
            }
            return Observable<Int>.timer(.seconds(delay), scheduler: MainScheduler.instance)
        }
    }
}
