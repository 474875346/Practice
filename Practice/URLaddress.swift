//
//  URLaddress.swift
//  Practice
//
//  Created by 新龙科技 on 2016/12/28.
//  Copyright © 2016年 新龙科技. All rights reserved.
//
//地址请求
import Foundation
//获取学院列表
let collegelist = "/api/college/list"
//发送验证码
let SendCode = "/api/message/send"
//验证验证码
let VerifyCode = "/api/message/verifyCode"
//重置密码
let ResetPsw = "/api/student/resetPass"
//学员注册
let Student_Register = "/api/student/register"
//学员登录
let Student_Login = "/api/student/login"
//消息列表
let Student_pageQuery = "/api/notice/pageQuery"
//学员退出登录
let Student_loginOut = "/api/student/loginOut"
//修改密码
let Student_changePass = "/api/student/changePass"
//学员信息
let Student_info = "/api/student/info"
//修改头像
let Student_ChangHead = "/api/student/changeHead"
//修改学员信息
let Student_save = "/api/student/save"
//消息未读条数
let Student_unread = "/api/notice/unread"
//学员是否签到
let Student_validSign = "/api/sign/validSign"
//学员签到
let Student_signIn = "/api/sign/signIn"
//学员签到记录
let Student_signRecord = "/api/sign/signRecord"
//月报上传
let  Student_reported = "/api/report/reported/ios"
//月报记录
let Student_reportquery = "/api/report/query"
//保存设备信息
let Student_positionsave = "/api/position/save"
//一键呼救
let Student_help = "/api/sos/help"
//在线咨询问题列表
let Student_questionlist = "/api/question/list"
//获取老师列表
let Student_questiongetTeacher = "/api/question/getTeacher"
//提交咨询问题
let Student_questionconsult = "/api/question/consult"
//咨询问题历史
let Student_getQuestionHistory = "/api/question/getQuestionHistory"
//咨询问题学生回复
let Student_questionreplay = "/api/question/replay"
