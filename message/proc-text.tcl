﻿# --------------------------------
# Oremo Chinese localization file
# By:Skywet/Raindropx
# Date:2019/03/06
# Oremo version:3.0-b190106
# --------------------------------
# ※特殊な設定
# 日本語フォントを設定する(ここで設定したフォントを使って以降の文字列を表示させる
#

set t(fontName) "Microsoft YaHei UI"

# --------------------------------
set t(setLanguage,opentitle)  "打开语言文件"

set t(.confm)        "已确认"
set t(.confm.r)      "加载"
set t(.confm.nr)     "不加载"
set t(.confm.fioErr) "文件读写错误"
set t(.confm.yes)    "是"
set t(.confm.no)     "否"
set t(.confm.ok)     "确认"
set t(.confm.apply)  "应用"
set t(.confm.run)    "运行"
set t(.confm.c)      "取消"
set t(.confm.errTitle) "错误"
set t(.confm.warnTitle) "警告"
set t(.confm.delParam)  "当前所有原音设定都将被移除,确认？"
set t(makeRecListFromDir,q)  "加载原音设定文件？"
set t(makeRecListFromDir,a)  "自动推算原音设定"
set t(makeRecListFromUST,title1)    "打开UST工程"
set t(makeRecListFromUST,errMsg)    "UST工程加载失败。"
set t(makeRecListFromUST,doneMsg)   "UST工程加载成功。"
set t(genParamWizard,title)  "音源类型"
set t(genParamWizard,q)      "选择目标音源的类型。"
set t(genParamWizard,a1)     "CV（单独音）"
set t(genParamWizard,a2)     "VCV（连续音）"
set t(saveRecList,title)     "保存录音表"
set t(saveRecList,errMsg)    "写入\$v(recListFile)失败。"
set t(saveRecList,errMsg2)   "音名写入失败。"
set t(saveRecList,doneMsg)   "录音表成功写入\$v(recListFile)。"
set t(saveCommentList,errMsg)] "无法保存注释文件。"
set t(readRecList,title1)    "加载录音表"
set t(readRecList,errMsg)    "从(\$v(recListFile))加载录音表失败。"
set t(readRecList,errMsg2)   "音名加载失败。"
set t(readRecList,doneMsg)   "\$v(recListFile)加载成功。"
set t(readRecList,overwrite) "在录音表文件夹中发现注释文件,是否加载？"
set t(readCommentList,errMsg)   "无法加载注释文件。"
set t(readCommentList,doneMsg)  "\$commNum 个注释加载成功"
set t(readCommentList,doneMsg2) "\$commNum 个注释加载成功（\$ignoreNum 个重复的注释）"
set t(readTypeList,title)    "加载声源类型列表"
set t(readTypeList,errMsg)   "（\$v(typeListFile)）发声类型表加载失败。"
set t(readTypeList,errMsg2)  "无法加载发声类型"
set t(readTypeList,doneMsg)  "\$v(typeListFile)发声类型加载成功。"
set t(choosesaveDir,title)   "设置录音目标文件夹"
set t(choosesaveDir,doneMsg) "录音目标文件夹设置成功。"
set t(choosesaveDir,q)       "要加载原音设定文件么？"
set t(saveWavFile,doneMsg)   "\$v(saveDir)/\$v(recLab)\$v(typeLab).wav保存成功。"
set t(waitWindow,title)      "正在计算F0……"
set t(bgmGuide,title)  "录音方式设置"
set t(bgmGuide,mode)   "录音模式："
set t(bgmGuide,r1)     "手动录音:长按'r'时录音（与OREMO 1.0版相同）"
set t(bgmGuide,r2)     "自动录音方案1:\n当'r'被按下,自动播放一遍录音BGM并录音\n音与音间的切换手动完成."
set t(bgmGuide,r3)     "自动录音方案2:\n当'r'被按下,循环播放录音BGM并自动录音\n音与音间的切换也是自动完成的"
set t(bgmGuide,r4)     "不录音"
set t(bgmGuide,bgm)    "录音BGM："
set t(bgmGuide,bTitle) "录音BGM设置"
set t(bgmGuide,play)   "播放"
set t(bgmGuide,stop)   "停止"
set t(bgmGuide,tplay)  "测试播放："
set t(testPlayBGM,errMsg)   "文件加载失败。"
set t(testPlayBGM,errTitle) "播放错误"
set t(tempoGuide,title)             "节奏引导"
set t(tempoGuide,click)             "节拍声："
set t(tempoGuide,clickTitle)        "节拍声设置"
set t(tempoGuide,tempo)             "曲速："
set t(tempoGuide,bpm)               "BPM = "
set t(tempoGuide,bpmUnit)           "毫秒/拍"
set t(tempoGuide,comment)           "* 按下'm'键在播放/停止间切换。"
set t(pitchGuide,title)             "音高引导"
set t(pitchGuide,sel)               "引导音频设置："
set t(pitchGuide,vol)               "音量："
set t(pitchGuide,comment)           "* 快捷键：o, 上下箭头, 2,4,6,8, Esc"
set t(genParam,title)  "生成连续音(VCV)的oto.ini"
set t(genParam,tempo)  "录音节奏："
set t(genParam,bpm)    "单位：bpm"
set t(genParam,S)      "发声开始："
set t(genParam,unit)   "单位："
set t(genParam,haku)   "拍"
set t(genParam,darrow) "↓　↓"
set t(genParam,bInit)  "根据录制曲速初始化参数"
set t(genParam,O)      "重叠(Ovl)："
set t(genParam,msec)   "：毫秒"
set t(genParam,P)      "预发声(Pre)："
set t(genParam,C)      "固定范围(Con)："
set t(genParam,E)      "右线(R)："
set t(genParam,do)     "生成参数"
set t(genParam,aliasMax)          "* 是否为重复的辅助记号添加序号？"
set t(genParam,aliasMaxNo)        "否（保留重复辅助记号）"
set t(genParam,aliasMaxYes)       "是（添加序号）"
set t(genParam,aliasMaxNum)       "最大序号（0=无穷）"
set t(genParam,autoAdjUSTRen)     "使用参数自动修正方案1（根据响度）"
set t(genParam,vLow)              "预发声前的响度低谷："
set t(genParam,sRange)            "预发声搜索范围："
set t(genParam,f0pow)             "* 同时使用F0及其他与响度有关的参数。"
set t(genParam,db)                "单位：dB"
set t(genParam,autoAdjUSTRen2)    "使用参数自动修正方案2（根据音频MFCC特征,速度较慢）"
set t(genParam,autoAdjUSTRen2Opt) "选项"
set t(genParam,autoAdjUSTRen2Pattern) "适用对象"
set t(doGenParam,doneMsg) "\$v(paramFile) 加载成功"
set t(checkWavForOREMO,saveQ)  "当前录音尚未保存"
set t(checkWavForOREMO,saveA1) "保存并继续"
set t(checkWavForOREMO,saveA2) "不保存并继续"
set t(checkWavForOREMO,saveA3) "取消"
set t(searchParam,title)     "搜索"
set t(searchParam,search)    "搜索"
set t(searchParam,rup)       "向下搜索"
set t(searchParam,rdown)     "向上搜索"
set t(searchParam,doneTitle) "搜索完成"
set t(searchParam,doneMsg)   "未找到"
set t(autoRecStart,errMsg)   "录音BGM文件(\$v(bgmFile))加载失败。"
set t(autoRecStart,errMsg2)  "录音BGM配置文件\$v(bgmParamFile)加载失败。"
set t(autoRecStart,errMsg3)  "非法单位设置"
set t(autoRecStart,errMsg4)  "请确认在配置文件(\$v(bgmParamFile))末端声明'重复'"
set t(autoRecStart,unit)     "单位"
set t(autoRecStop,doneMsg)   "已接受自动录音停止请求。"
set t(toggleMetroPlay,stopMsg)  "播放/停止节奏引导音频"
set t(toggleMetroPlay,errTitle) "节奏引导故障"
set t(toggleMetroPlay,errMsg)   "引导节奏必须在50-200bpm之间。"
set t(toggleMetroPlay,errMsg2)  "节奏引导用wav文件(\$v(clickWav))未找到。"
set t(toggleMetroPlay,playMsg)  "正在播放节奏引导……（按下'm'以停止播放）"
set t(toggleMetroPlay,errPa)  "节拍器播放失败。"
set t(toggleOnsaPlay,stopMsg) "播放/停止音高引导"
set t(toggleOnsaPlay,playMsg) "正在播放音高引导……(按下'o'以停止播放)"
set t(togglePlay,stopMsg) "已停止"
set t(togglePlay,playMsg) "正在播放……"
set t(chooseColor,title) "颜色设置"
set t(setColor,selColor) "颜色设置"
set t(packToneList,play)   "播放"
set t(packToneList,repeat) "持续"
set t(saveSettings,title)  "生成配置文件"
set t(setIODevice,errPa)  "PortAudio设备配置失效。"
set t(setIODevice,errPa2) "选择供PortAudio使用的输入设备"
set t(setIODevice,errPa3) "确认PortAudio中的输入通道数"
set t(setIODevice,errPa4) "确认PortAudio中的采样率"
set t(setIODevice,errPa5) "确认PortAudio的缓冲区大小"
set t(setIODevice,errPaOut2) "选择PortAudio的输出设备"
set t(ioSettings,title)    "音频输入/输出设置"
set t(ioSettings,inDev)    "输入设备："
set t(ioSettings,outDev)   "输出设备："
set t(ioSettings,inGain)   "输入增幅(需设备支持)："
set t(ioSettings,outGain)  "输出增幅(需设备支持)："
set t(ioSettings,latency)  "延迟(需设备支持)："
set t(ioSettings,sndBuffer) "录音缓冲区大小："
set t(ioSettings,bgmBuffer) "录音BGM缓冲区大小："
set t(ioSettings,comment0) "* 建议保留本窗口中各项设置为默认(Device = Wave Mapper)。"
set t(ioSettings,comment0b) "* 尤其需注意,DirectSound在日本版Windows的Snack-lib下不稳定。"
set t(ioSettings,comment1) "* 除非按下'应用'或'确认'按钮,否则设置将不会生效。"
set t(ioSettings,comment2) ""
set t(ioSettings,useRequestRec)  "启用录制"
set t(ioSettings,useRequestPlay) "启用播放"
set t(ioSettings,sampleRate) "采样率(Hz)："
set t(ioSettings,format)     "位数："
set t(ioSettings,inChannel)  "输入通道数："
set t(ioSettings,bufferSize)  "缓冲区大小："
set t(ioSettings,portaudio)   "PortAudio"
set t(autoParamEstimation,title)     "执行外部工具(自动参数推算)"
set t(autoParamEstimation,aepTool)   "外部工具"
set t(autoParamEstimation,selTitle)  "外部工具位置"
set t(autoParamEstimation,option)    "外部工具启动脚本"
set t(autoParamEstimation,aepResult) "外部工具输出文件"
set t(autoParamEstimation,runMsg)    "启动外部工具"
set t(autoParamEstimation,resultMsg) "取得外部工具的运行结果"
set t(estimateParam,title)       "自动参数推定(CV单独音)"
set t(estimateParam,pFLen)       "响度采样单位"
set t(estimateParam,preemph)     "预加重"
set t(estimateParam,pWinLen)     "响度采样窗口长度"
set t(estimateParam,pWinkind)    "窗口类型"
set t(estimateParam,pUttMin)     "发音的最低响度"
set t(estimateParam,vLow)        "元音的最低响度"
set t(estimateParam,pUttMinTime) "最短录音长度"
set t(estimateParam,uttLen)      "录音响度敏感度"
set t(estimateParam,silMax)      "静音区的最高响度"
set t(estimateParam,silMinTime)  "最短静音长度"
set t(estimateParam,minC)        "最短辅音长度"
set t(estimateParam,f0)          "(注：)F0也被用作参数推定。"
set t(estimateParam,target)      "推定目标"
set t(estimateParam,S)           "左边界(L)"
set t(estimateParam,C)           "固定范围(Con)"
set t(estimateParam,E)           "右边界(R)"
set t(estimateParam,P)           "预发声(Pre)"
set t(estimateParam,O)           "重叠(Ovl)"
set t(estimateParam,overWrite)   "当前的原音设定参数将被覆盖,是否继续？"
set t(estimateParam,runAll)      "应用到所有的波形文件"
set t(estimateParam,runSel)      "应用到选定的波形文件"
set t(doEstimateParam,startMsg)  "正在推算参数……"
set t(doEstimateParam,doneMsg)   "参数推算完成"
set t(readParamFile,selMsg)   "原音设定参数选择"
set t(readParamFile,startMsg) "正在加载原音设定参数……"
set t(readParamFile,errMsg)   "\$v(paramFile)指向了\$v(saveDir) /中不存在的wav文件。"
set t(readParamFile,example)  "例如："
set t(readParamFile,errMsg2)  "缺少的条目已添加到\$v(paramFile)"
set t(readParamFile,doneMsg)  "\$v(paramFile)加载成功。"
set t(saveParamFile,selFile)  "保存原音设定参数"
set t(saveParamFile,startMsg) "正在保存原音设定参数……"
set t(saveParamFile,doneMsg)  "原音设定参数保存成功。"
set t(settings,title)        "高级设置"
set t(settings,wave)         "<波形>"
set t(settings,waveColor)    "波形颜色："
set t(settings,waveScale)    "纵轴最大坐标(0-32768,0=自动缩放)"
set t(settings,sampleRate)   "采样率（单位：Hz）："
set t(settings,spec)         "<频谱>"
set t(settings,specColor)    "频谱颜色："
set t(settings,maxFreq)      "最高频率（单位：Hz）："
set t(settings,brightness)   "明亮度："
set t(settings,contrast)     "对比度："
set t(settings,fftLength)    "FFT长度（单位：采样）："
set t(settings,fftWinLength) "窗口宽度（单位：采样）："
set t(settings,fftPreemph)   "预加重："
set t(settings,fftWinKind)   "窗口类型"
set t(settings,pow)          "<响度>"
set t(settings,powColor)     "响度曲线颜色："
set t(settings,powLength)    "响度采样单位（单位：秒）："
set t(settings,powPreemph)   "预加重："
set t(settings,winLength)    "窗口宽度（单位：秒）："
set t(settings,powWinKind)   "窗口类型："
set t(settings,f0)           "<F0（音高）>"
set t(settings,f0Color)      "F0曲线颜色："
set t(settings,f0Argo)       "分析算法："
set t(settings,f0Length)     "F0采样率（单位：秒）："
set t(settings,f0WinLength)  "窗口宽度（单位：秒）："
set t(settings,f0Max)        "最大F0（单位：Hz）："
set t(settings,f0Min)        "最小F0（单位：Hz）："
set t(settings,f0Unit)       "显示单位："
set t(settings,f0FixRange)   "聚焦显示区域："
set t(settings,f0FixRange,h) "最大："
set t(settings,f0FixRange,l) "最小："
set t(settings,grid)         "显示钢琴格"
set t(settings,gridColor)    "格子颜色："
set t(settings,target)       "显示目标音高"
set t(settings,targetTone)   "目标音高："
set t(settings,targetColor)  "目标音高颜色："
set t(settings,autoSetting)  "根据目标改变参数："
set t(recStart,msg) "正在录音……"
set t(recStart,errPa)  "使用PortAudio的录音任务启动失败"
set t(aRecStart,errPa)  "使用PortAudio的录音任务启动失败"
set t(aRecStop,errPa)  "使用PortAudio的录音任务停止失败"
set t(paRecRun,errMsg) "oremo-recorder.exe无法运行"
set t(paRecRun,errDev) "录音设备无法使用。"
set t(paPlayRun,errMsg) "oremo-player.exe无法运行"
set t(paPlayRun,errDev) "播放设备无法使用。"
set t(recStop,msg)  "录音停止"
set t(recStop,errPa)  "使用PortAudio的录音任务停止失败"
set t(Exit,q2) "当前录音文件未保存,是否要保存？"
set t(Exit,a1) "保存并退出"
set t(Exit,a2) "不保存退出"
set t(Exit,a3) "取消"
set t(PopUpMenu,showWave)   "显示波形"
set t(PopUpMenu,showSpec)   "显示频谱"
set t(PopUpMenu,showPow)    "显示响度"
set t(PopUpMenu,showF0)     "显示F0"
set t(PopUpMenu,pitchGuide) "显示音高向导"
set t(PopUpMenu,tempoGuide) "显示节奏向导"
set t(PopUpMenu,settings)   "偏好设置"
set t(PopUpMenu,zoomTitle)  "时间轴缩放"
set t(PopUpMenu,zoom100)    "x1（显示整个波形）"
set t(PopUpMenu,zoom1000)   "x10"
set t(PopUpMenu,zoom5000)   "x50"
set t(PopUpMenu,zoom10000)  "x100"
set t(PopUpMenu,zoomMax)    "最大缩放"
set t(Version,msg) "版本"
set t(initParamU,0) "音频"
set t(initParamU,1) "左边界(L)"
set t(initParamU,2) "重叠(Ovl)"
set t(initParamU,3) "预发声(Pre)"
set t(initParamU,4) "固定范围(Con)"
set t(initParamU,5) "右边界(R)"
set t(initParamU,6) "辅助记号(别名)"
set t(searchComment,title)     "搜索"
set t(searchComment,search)    "搜索"
set t(searchComment,rup)       "向下搜索"
set t(searchComment,rdown)     "向上搜索"
set t(searchComment,doneTitle) "搜索完成。"
set t(searchComment,doneMsg)   "未找到匹配项。"
set t(searchComment,rMatch1)   "精确匹配"
set t(searchComment,rMatch2)   "部分匹配"
set t(bindWindow,record)      "录音开始&停止"
set t(bindWindow,recStop)     "自动录音停止"
set t(bindWindow,nextRec)     "下一个音"
set t(bindWindow,prevRec)     "上一个音"
set t(bindWindow,nextType)    "下一种发声类型"
set t(bindWindow,prevType)    "上一种发声类型"
set t(bindWindow,nextRec0)    "下一个音(不保存)"
set t(bindWindow,prevRec0)    "上一个音(不保存)"
set t(bindWindow,nextType0)   "下一种发声类型(不保存)"
set t(bindWindow,prevType0)   "上一种发声类型(不保存)"
set t(bindWindow,togglePlay)  "播放开始&停止"
set t(bindWindow,toggleOnsaPlay)   "音叉开始&停止"
set t(bindWindow,toggleMetroPlay)  "节拍器开始&停止"
set t(bindWindow,searchComment)    "搜索注释"
set t(bindWindow,waveReload)  "重新加载波形文件"
set t(bindWindow,waveExpand)  "扩大"
set t(bindWindow,waveShrink)  "缩小"
set t(bindWindow,ex)          "例如 a, A, Ctrl-a, Alt-a, Ctrl-Alt-a"
set t(bindWindow,ex2)         "例如 空格, F1, F2"
set t(bindWindow,ex3)         "* 更改的快捷键在程序重新启动前不会生效。"
set t(bindWindow,errTitle)    "快捷键错误"
set t(bindWindow,errMsg)      "非法输入（\$value）"
set t(fontWindow,attention)   "设置将在程序重启后生效。"
set t(fontWindow,attention2)  "oremo-setting.ini中autoSaveInitFile = 0时设置将被忽略"
set t(fontWindow,lbfs)        "录音区字号"
set t(fontWindow,lfs)         "录音表字号"
set t(fontWindow,lcfs)        "注释区字号"
set t(isSetparamComment,q)    "是否将该文件加载为setParam生成的注释文件？"
