//
//  File.swift
//  Random
//
//  Created by yu mingming on 2020/7/21.
//  Copyright © 2020 刘超正. All rights reserved.
//

import Foundation

class AppleCmsDetailsListModel : NSObject, NSCoding, Mappable{

    var groupId : Int?
    var typeId : Int?
    var typeId1 : Int?
    var typeName : String?
    var vodActor : String?
    var vodArea : String?
    var vodAuthor : String?
    var vodBehind : String?
    var vodBlurb : String?
    var vodClass : String?
    var vodColor : String?
    var vodContent : String?
    var vodCopyright : Int?
    var vodDirector : String?
    var vodDoubanId : Int?
    var vodDoubanScore : String?
    var vodDown : Int?
    var vodDownFrom : String?
    var vodDownNote : String?
    var vodDownServer : String?
    var vodDownUrl : String?
    var vodDuration : String?
    var vodEn : String?
    var vodHits : Int?
    var vodHitsDay : Int?
    var vodHitsMonth : Int?
    var vodHitsWeek : Int?
    var vodId : Int?
    var vodIsend : Int?
    var vodJumpurl : String?
    var vodLang : String?
    var vodLetter : String?
    var vodLevel : Int?
    var vodLock : Int?
    var vodName : String?
    var vodPic : String?
    var vodPicSlide : String?
    var vodPicThumb : String?
    var vodPlayFrom : String?
    var vodPlayNote : String?
    var vodPlayServer : String?
    var vodPlayUrl : String?
    var vodPlot : Int?
    var vodPlotDetail : String?
    var vodPlotName : String?
    var vodPoints : Int?
    var vodPointsDown : Int?
    var vodPointsPlay : Int?
    var vodPubdate : String?
    var vodPwd : String?
    var vodPwdDown : String?
    var vodPwdDownUrl : String?
    var vodPwdPlay : String?
    var vodPwdPlayUrl : String?
    var vodPwdUrl : String?
    var vodRelArt : String?
    var vodRelVod : String?
    var vodRemarks : String?
    var vodReurl : String?
    var vodScore : String?
    var vodScoreAll : Int?
    var vodScoreNum : Int?
    var vodSerial : String?
    var vodState : String?
    var vodStatus : Int?
    var vodSub : String?
    var vodTag : String?
    var vodTime : String?
    var vodTimeAdd : Int?
    var vodTimeHits : Int?
    var vodTimeMake : Int?
    var vodTotal : Int?
    var vodTpl : String?
    var vodTplDown : String?
    var vodTplPlay : String?
    var vodTrysee : Int?
    var vodTv : String?
    var vodUp : Int?
    var vodVersion : String?
    var vodWeekday : String?
    var vodWriter : String?
    var vodYear : String?

    class func newInstance(map: Map) -> Mappable?{
        return AppleCmsDetailsListModel()
    }
    required init?(map: Map){}
    private override init(){}

    func mapping(map: Map)
    {
        groupId <- map["group_id"]
        typeId <- map["type_id"]
        typeId1 <- map["type_id_1"]
        typeName <- map["type_name"]
        vodActor <- map["vod_actor"]
        vodArea <- map["vod_area"]
        vodAuthor <- map["vod_author"]
        vodBehind <- map["vod_behind"]
        vodBlurb <- map["vod_blurb"]
        vodClass <- map["vod_class"]
        vodColor <- map["vod_color"]
        vodContent <- map["vod_content"]
        vodCopyright <- map["vod_copyright"]
        vodDirector <- map["vod_director"]
        vodDoubanId <- map["vod_douban_id"]
        vodDoubanScore <- map["vod_douban_score"]
        vodDown <- map["vod_down"]
        vodDownFrom <- map["vod_down_from"]
        vodDownNote <- map["vod_down_note"]
        vodDownServer <- map["vod_down_server"]
        vodDownUrl <- map["vod_down_url"]
        vodDuration <- map["vod_duration"]
        vodEn <- map["vod_en"]
        vodHits <- map["vod_hits"]
        vodHitsDay <- map["vod_hits_day"]
        vodHitsMonth <- map["vod_hits_month"]
        vodHitsWeek <- map["vod_hits_week"]
        vodId <- map["vod_id"]
        vodIsend <- map["vod_isend"]
        vodJumpurl <- map["vod_jumpurl"]
        vodLang <- map["vod_lang"]
        vodLetter <- map["vod_letter"]
        vodLevel <- map["vod_level"]
        vodLock <- map["vod_lock"]
        vodName <- map["vod_name"]
        vodPic <- map["vod_pic"]
        vodPicSlide <- map["vod_pic_slide"]
        vodPicThumb <- map["vod_pic_thumb"]
        vodPlayFrom <- map["vod_play_from"]
        vodPlayNote <- map["vod_play_note"]
        vodPlayServer <- map["vod_play_server"]
        vodPlayUrl <- map["vod_play_url"]
        vodPlot <- map["vod_plot"]
        vodPlotDetail <- map["vod_plot_detail"]
        vodPlotName <- map["vod_plot_name"]
        vodPoints <- map["vod_points"]
        vodPointsDown <- map["vod_points_down"]
        vodPointsPlay <- map["vod_points_play"]
        vodPubdate <- map["vod_pubdate"]
        vodPwd <- map["vod_pwd"]
        vodPwdDown <- map["vod_pwd_down"]
        vodPwdDownUrl <- map["vod_pwd_down_url"]
        vodPwdPlay <- map["vod_pwd_play"]
        vodPwdPlayUrl <- map["vod_pwd_play_url"]
        vodPwdUrl <- map["vod_pwd_url"]
        vodRelArt <- map["vod_rel_art"]
        vodRelVod <- map["vod_rel_vod"]
        vodRemarks <- map["vod_remarks"]
        vodReurl <- map["vod_reurl"]
        vodScore <- map["vod_score"]
        vodScoreAll <- map["vod_score_all"]
        vodScoreNum <- map["vod_score_num"]
        vodSerial <- map["vod_serial"]
        vodState <- map["vod_state"]
        vodStatus <- map["vod_status"]
        vodSub <- map["vod_sub"]
        vodTag <- map["vod_tag"]
        vodTime <- map["vod_time"]
        vodTimeAdd <- map["vod_time_add"]
        vodTimeHits <- map["vod_time_hits"]
        vodTimeMake <- map["vod_time_make"]
        vodTotal <- map["vod_total"]
        vodTpl <- map["vod_tpl"]
        vodTplDown <- map["vod_tpl_down"]
        vodTplPlay <- map["vod_tpl_play"]
        vodTrysee <- map["vod_trysee"]
        vodTv <- map["vod_tv"]
        vodUp <- map["vod_up"]
        vodVersion <- map["vod_version"]
        vodWeekday <- map["vod_weekday"]
        vodWriter <- map["vod_writer"]
        vodYear <- map["vod_year"]
        
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
         groupId = aDecoder.decodeObject(forKey: "group_id") as? Int
         typeId = aDecoder.decodeObject(forKey: "type_id") as? Int
         typeId1 = aDecoder.decodeObject(forKey: "type_id_1") as? Int
         typeName = aDecoder.decodeObject(forKey: "type_name") as? String
         vodActor = aDecoder.decodeObject(forKey: "vod_actor") as? String
         vodArea = aDecoder.decodeObject(forKey: "vod_area") as? String
         vodAuthor = aDecoder.decodeObject(forKey: "vod_author") as? String
         vodBehind = aDecoder.decodeObject(forKey: "vod_behind") as? String
         vodBlurb = aDecoder.decodeObject(forKey: "vod_blurb") as? String
         vodClass = aDecoder.decodeObject(forKey: "vod_class") as? String
         vodColor = aDecoder.decodeObject(forKey: "vod_color") as? String
         vodContent = aDecoder.decodeObject(forKey: "vod_content") as? String
         vodCopyright = aDecoder.decodeObject(forKey: "vod_copyright") as? Int
         vodDirector = aDecoder.decodeObject(forKey: "vod_director") as? String
         vodDoubanId = aDecoder.decodeObject(forKey: "vod_douban_id") as? Int
         vodDoubanScore = aDecoder.decodeObject(forKey: "vod_douban_score") as? String
         vodDown = aDecoder.decodeObject(forKey: "vod_down") as? Int
         vodDownFrom = aDecoder.decodeObject(forKey: "vod_down_from") as? String
         vodDownNote = aDecoder.decodeObject(forKey: "vod_down_note") as? String
         vodDownServer = aDecoder.decodeObject(forKey: "vod_down_server") as? String
         vodDownUrl = aDecoder.decodeObject(forKey: "vod_down_url") as? String
         vodDuration = aDecoder.decodeObject(forKey: "vod_duration") as? String
         vodEn = aDecoder.decodeObject(forKey: "vod_en") as? String
         vodHits = aDecoder.decodeObject(forKey: "vod_hits") as? Int
         vodHitsDay = aDecoder.decodeObject(forKey: "vod_hits_day") as? Int
         vodHitsMonth = aDecoder.decodeObject(forKey: "vod_hits_month") as? Int
         vodHitsWeek = aDecoder.decodeObject(forKey: "vod_hits_week") as? Int
         vodId = aDecoder.decodeObject(forKey: "vod_id") as? Int
         vodIsend = aDecoder.decodeObject(forKey: "vod_isend") as? Int
         vodJumpurl = aDecoder.decodeObject(forKey: "vod_jumpurl") as? String
         vodLang = aDecoder.decodeObject(forKey: "vod_lang") as? String
         vodLetter = aDecoder.decodeObject(forKey: "vod_letter") as? String
         vodLevel = aDecoder.decodeObject(forKey: "vod_level") as? Int
         vodLock = aDecoder.decodeObject(forKey: "vod_lock") as? Int
         vodName = aDecoder.decodeObject(forKey: "vod_name") as? String
         vodPic = aDecoder.decodeObject(forKey: "vod_pic") as? String
         vodPicSlide = aDecoder.decodeObject(forKey: "vod_pic_slide") as? String
         vodPicThumb = aDecoder.decodeObject(forKey: "vod_pic_thumb") as? String
         vodPlayFrom = aDecoder.decodeObject(forKey: "vod_play_from") as? String
         vodPlayNote = aDecoder.decodeObject(forKey: "vod_play_note") as? String
         vodPlayServer = aDecoder.decodeObject(forKey: "vod_play_server") as? String
         vodPlayUrl = aDecoder.decodeObject(forKey: "vod_play_url") as? String
         vodPlot = aDecoder.decodeObject(forKey: "vod_plot") as? Int
         vodPlotDetail = aDecoder.decodeObject(forKey: "vod_plot_detail") as? String
         vodPlotName = aDecoder.decodeObject(forKey: "vod_plot_name") as? String
         vodPoints = aDecoder.decodeObject(forKey: "vod_points") as? Int
         vodPointsDown = aDecoder.decodeObject(forKey: "vod_points_down") as? Int
         vodPointsPlay = aDecoder.decodeObject(forKey: "vod_points_play") as? Int
         vodPubdate = aDecoder.decodeObject(forKey: "vod_pubdate") as? String
         vodPwd = aDecoder.decodeObject(forKey: "vod_pwd") as? String
         vodPwdDown = aDecoder.decodeObject(forKey: "vod_pwd_down") as? String
         vodPwdDownUrl = aDecoder.decodeObject(forKey: "vod_pwd_down_url") as? String
         vodPwdPlay = aDecoder.decodeObject(forKey: "vod_pwd_play") as? String
         vodPwdPlayUrl = aDecoder.decodeObject(forKey: "vod_pwd_play_url") as? String
         vodPwdUrl = aDecoder.decodeObject(forKey: "vod_pwd_url") as? String
         vodRelArt = aDecoder.decodeObject(forKey: "vod_rel_art") as? String
         vodRelVod = aDecoder.decodeObject(forKey: "vod_rel_vod") as? String
         vodRemarks = aDecoder.decodeObject(forKey: "vod_remarks") as? String
         vodReurl = aDecoder.decodeObject(forKey: "vod_reurl") as? String
         vodScore = aDecoder.decodeObject(forKey: "vod_score") as? String
         vodScoreAll = aDecoder.decodeObject(forKey: "vod_score_all") as? Int
         vodScoreNum = aDecoder.decodeObject(forKey: "vod_score_num") as? Int
         vodSerial = aDecoder.decodeObject(forKey: "vod_serial") as? String
         vodState = aDecoder.decodeObject(forKey: "vod_state") as? String
         vodStatus = aDecoder.decodeObject(forKey: "vod_status") as? Int
         vodSub = aDecoder.decodeObject(forKey: "vod_sub") as? String
         vodTag = aDecoder.decodeObject(forKey: "vod_tag") as? String
         vodTime = aDecoder.decodeObject(forKey: "vod_time") as? String
         vodTimeAdd = aDecoder.decodeObject(forKey: "vod_time_add") as? Int
         vodTimeHits = aDecoder.decodeObject(forKey: "vod_time_hits") as? Int
         vodTimeMake = aDecoder.decodeObject(forKey: "vod_time_make") as? Int
         vodTotal = aDecoder.decodeObject(forKey: "vod_total") as? Int
         vodTpl = aDecoder.decodeObject(forKey: "vod_tpl") as? String
         vodTplDown = aDecoder.decodeObject(forKey: "vod_tpl_down") as? String
         vodTplPlay = aDecoder.decodeObject(forKey: "vod_tpl_play") as? String
         vodTrysee = aDecoder.decodeObject(forKey: "vod_trysee") as? Int
         vodTv = aDecoder.decodeObject(forKey: "vod_tv") as? String
         vodUp = aDecoder.decodeObject(forKey: "vod_up") as? Int
         vodVersion = aDecoder.decodeObject(forKey: "vod_version") as? String
         vodWeekday = aDecoder.decodeObject(forKey: "vod_weekday") as? String
         vodWriter = aDecoder.decodeObject(forKey: "vod_writer") as? String
         vodYear = aDecoder.decodeObject(forKey: "vod_year") as? String
    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
    {
        if groupId != nil{
            aCoder.encode(groupId, forKey: "group_id")
        }
        if typeId != nil{
            aCoder.encode(typeId, forKey: "type_id")
        }
        if typeId1 != nil{
            aCoder.encode(typeId1, forKey: "type_id_1")
        }
        if typeName != nil{
            aCoder.encode(typeName, forKey: "type_name")
        }
        if vodActor != nil{
            aCoder.encode(vodActor, forKey: "vod_actor")
        }
        if vodArea != nil{
            aCoder.encode(vodArea, forKey: "vod_area")
        }
        if vodAuthor != nil{
            aCoder.encode(vodAuthor, forKey: "vod_author")
        }
        if vodBehind != nil{
            aCoder.encode(vodBehind, forKey: "vod_behind")
        }
        if vodBlurb != nil{
            aCoder.encode(vodBlurb, forKey: "vod_blurb")
        }
        if vodClass != nil{
            aCoder.encode(vodClass, forKey: "vod_class")
        }
        if vodColor != nil{
            aCoder.encode(vodColor, forKey: "vod_color")
        }
        if vodContent != nil{
            aCoder.encode(vodContent, forKey: "vod_content")
        }
        if vodCopyright != nil{
            aCoder.encode(vodCopyright, forKey: "vod_copyright")
        }
        if vodDirector != nil{
            aCoder.encode(vodDirector, forKey: "vod_director")
        }
        if vodDoubanId != nil{
            aCoder.encode(vodDoubanId, forKey: "vod_douban_id")
        }
        if vodDoubanScore != nil{
            aCoder.encode(vodDoubanScore, forKey: "vod_douban_score")
        }
        if vodDown != nil{
            aCoder.encode(vodDown, forKey: "vod_down")
        }
        if vodDownFrom != nil{
            aCoder.encode(vodDownFrom, forKey: "vod_down_from")
        }
        if vodDownNote != nil{
            aCoder.encode(vodDownNote, forKey: "vod_down_note")
        }
        if vodDownServer != nil{
            aCoder.encode(vodDownServer, forKey: "vod_down_server")
        }
        if vodDownUrl != nil{
            aCoder.encode(vodDownUrl, forKey: "vod_down_url")
        }
        if vodDuration != nil{
            aCoder.encode(vodDuration, forKey: "vod_duration")
        }
        if vodEn != nil{
            aCoder.encode(vodEn, forKey: "vod_en")
        }
        if vodHits != nil{
            aCoder.encode(vodHits, forKey: "vod_hits")
        }
        if vodHitsDay != nil{
            aCoder.encode(vodHitsDay, forKey: "vod_hits_day")
        }
        if vodHitsMonth != nil{
            aCoder.encode(vodHitsMonth, forKey: "vod_hits_month")
        }
        if vodHitsWeek != nil{
            aCoder.encode(vodHitsWeek, forKey: "vod_hits_week")
        }
        if vodId != nil{
            aCoder.encode(vodId, forKey: "vod_id")
        }
        if vodIsend != nil{
            aCoder.encode(vodIsend, forKey: "vod_isend")
        }
        if vodJumpurl != nil{
            aCoder.encode(vodJumpurl, forKey: "vod_jumpurl")
        }
        if vodLang != nil{
            aCoder.encode(vodLang, forKey: "vod_lang")
        }
        if vodLetter != nil{
            aCoder.encode(vodLetter, forKey: "vod_letter")
        }
        if vodLevel != nil{
            aCoder.encode(vodLevel, forKey: "vod_level")
        }
        if vodLock != nil{
            aCoder.encode(vodLock, forKey: "vod_lock")
        }
        if vodName != nil{
            aCoder.encode(vodName, forKey: "vod_name")
        }
        if vodPic != nil{
            aCoder.encode(vodPic, forKey: "vod_pic")
        }
        if vodPicSlide != nil{
            aCoder.encode(vodPicSlide, forKey: "vod_pic_slide")
        }
        if vodPicThumb != nil{
            aCoder.encode(vodPicThumb, forKey: "vod_pic_thumb")
        }
        if vodPlayFrom != nil{
            aCoder.encode(vodPlayFrom, forKey: "vod_play_from")
        }
        if vodPlayNote != nil{
            aCoder.encode(vodPlayNote, forKey: "vod_play_note")
        }
        if vodPlayServer != nil{
            aCoder.encode(vodPlayServer, forKey: "vod_play_server")
        }
        if vodPlayUrl != nil{
            aCoder.encode(vodPlayUrl, forKey: "vod_play_url")
        }
        if vodPlot != nil{
            aCoder.encode(vodPlot, forKey: "vod_plot")
        }
        if vodPlotDetail != nil{
            aCoder.encode(vodPlotDetail, forKey: "vod_plot_detail")
        }
        if vodPlotName != nil{
            aCoder.encode(vodPlotName, forKey: "vod_plot_name")
        }
        if vodPoints != nil{
            aCoder.encode(vodPoints, forKey: "vod_points")
        }
        if vodPointsDown != nil{
            aCoder.encode(vodPointsDown, forKey: "vod_points_down")
        }
        if vodPointsPlay != nil{
            aCoder.encode(vodPointsPlay, forKey: "vod_points_play")
        }
        if vodPubdate != nil{
            aCoder.encode(vodPubdate, forKey: "vod_pubdate")
        }
        if vodPwd != nil{
            aCoder.encode(vodPwd, forKey: "vod_pwd")
        }
        if vodPwdDown != nil{
            aCoder.encode(vodPwdDown, forKey: "vod_pwd_down")
        }
        if vodPwdDownUrl != nil{
            aCoder.encode(vodPwdDownUrl, forKey: "vod_pwd_down_url")
        }
        if vodPwdPlay != nil{
            aCoder.encode(vodPwdPlay, forKey: "vod_pwd_play")
        }
        if vodPwdPlayUrl != nil{
            aCoder.encode(vodPwdPlayUrl, forKey: "vod_pwd_play_url")
        }
        if vodPwdUrl != nil{
            aCoder.encode(vodPwdUrl, forKey: "vod_pwd_url")
        }
        if vodRelArt != nil{
            aCoder.encode(vodRelArt, forKey: "vod_rel_art")
        }
        if vodRelVod != nil{
            aCoder.encode(vodRelVod, forKey: "vod_rel_vod")
        }
        if vodRemarks != nil{
            aCoder.encode(vodRemarks, forKey: "vod_remarks")
        }
        if vodReurl != nil{
            aCoder.encode(vodReurl, forKey: "vod_reurl")
        }
        if vodScore != nil{
            aCoder.encode(vodScore, forKey: "vod_score")
        }
        if vodScoreAll != nil{
            aCoder.encode(vodScoreAll, forKey: "vod_score_all")
        }
        if vodScoreNum != nil{
            aCoder.encode(vodScoreNum, forKey: "vod_score_num")
        }
        if vodSerial != nil{
            aCoder.encode(vodSerial, forKey: "vod_serial")
        }
        if vodState != nil{
            aCoder.encode(vodState, forKey: "vod_state")
        }
        if vodStatus != nil{
            aCoder.encode(vodStatus, forKey: "vod_status")
        }
        if vodSub != nil{
            aCoder.encode(vodSub, forKey: "vod_sub")
        }
        if vodTag != nil{
            aCoder.encode(vodTag, forKey: "vod_tag")
        }
        if vodTime != nil{
            aCoder.encode(vodTime, forKey: "vod_time")
        }
        if vodTimeAdd != nil{
            aCoder.encode(vodTimeAdd, forKey: "vod_time_add")
        }
        if vodTimeHits != nil{
            aCoder.encode(vodTimeHits, forKey: "vod_time_hits")
        }
        if vodTimeMake != nil{
            aCoder.encode(vodTimeMake, forKey: "vod_time_make")
        }
        if vodTotal != nil{
            aCoder.encode(vodTotal, forKey: "vod_total")
        }
        if vodTpl != nil{
            aCoder.encode(vodTpl, forKey: "vod_tpl")
        }
        if vodTplDown != nil{
            aCoder.encode(vodTplDown, forKey: "vod_tpl_down")
        }
        if vodTplPlay != nil{
            aCoder.encode(vodTplPlay, forKey: "vod_tpl_play")
        }
        if vodTrysee != nil{
            aCoder.encode(vodTrysee, forKey: "vod_trysee")
        }
        if vodTv != nil{
            aCoder.encode(vodTv, forKey: "vod_tv")
        }
        if vodUp != nil{
            aCoder.encode(vodUp, forKey: "vod_up")
        }
        if vodVersion != nil{
            aCoder.encode(vodVersion, forKey: "vod_version")
        }
        if vodWeekday != nil{
            aCoder.encode(vodWeekday, forKey: "vod_weekday")
        }
        if vodWriter != nil{
            aCoder.encode(vodWriter, forKey: "vod_writer")
        }
        if vodYear != nil{
            aCoder.encode(vodYear, forKey: "vod_year")
        }
    }

}
