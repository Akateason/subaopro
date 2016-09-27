//
//  UrlRequestHeader.h
//  SuBaoJiang
//
//  Created by apple on 15/6/4.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#ifndef SuBaoJiang_UrlRequestHeader_h
#define SuBaoJiang_UrlRequestHeader_h

//  服务器ip地址切换
static NSString *const G_IP_SERVER              = @"http://cms.subaojiang.com/" ;

//  获取骑牛token
static NSString *const URL_QINIU_TOKEN          = @"Index/get_qiniu_token" ;

//  微猫
static NSString *const URL_WEMART_SIGN          = @"http://api3.subaojiang.com/Wemart/sign" ;

//  获取类型 列表 .                        i/h
static NSString *const URL_KIND_ALL             = @"kind/all" ;

//  获取内容列表    app                    i/h
static NSString *const URL_CONTENT_ALIST        = @"content/alist" ;

//  获取内容详情                            i/hP : 内容id .
static NSString *const URL_CONTENT_DETAIL       = @"content/detail" ;

//  按标题搜索 获取内容列表
static NSString *const URL_SEARCH_BY_TITLE      = @"content/searchByTitle" ;

//  按标签搜索 获取内容列表          i/h
static NSString *const URL_SEARCH_BY_TAG        = @"content/searchByTag" ;

//  标签 模糊搜索  返回列表            h
static NSString *const URL_TAG_SEARCH           = @"tag/search" ;

//  增加阅读数
static NSString *const URL_ADD_READ             = @"content/addRead" ;


// 一直播 列表
static NSString *const URL_YZB_LIST             = @"http://api.open.xiaoka.tv/openapi/live/get_hot_live_video" ;

#endif
