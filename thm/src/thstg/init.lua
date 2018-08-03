--[[
/**
 * @Author: cnscj 
 * @Version: v1.0 
 * @Date: 2018-06-27 12:07:21 
 * @Brief: THSTG库初始化加载
 * @Last Modified by: cnscj
 * @Last Modified time: 2018-06-27 13:23:09
 * @Last Modified log: 
 */
 ]]
THSTG = THSTG or {}

--加载全局宏
require "thstg.Scripts.Test"

--常规
require "thstg.Scripts.Frame.Common.Init"

--组件
require "thstg.Scripts.Frame.Component.Init"

--MVC
require "thstg.Scripts.Frame.MVC.Init"

--UI库
require "thstg.Scripts.Frame.UI.Init"

--辅助库
require "thstg.Scripts.Frame.Utils.FileUtil"
require "thstg.Scripts.Frame.Utils.TableUtil"
require "thstg.Scripts.Frame.Utils.UIDUtil"
