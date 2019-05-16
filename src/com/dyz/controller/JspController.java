package com.dyz.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class JspController {
	@RequestMapping(value="/crm",method=RequestMethod.GET)
	public ModelAndView loginUser() {
		return new ModelAndView("/demo/login"); 
	}
	 @RequestMapping(value="/crmIndex",method=RequestMethod.GET)
	 public ModelAndView loginUserIndex() {
		return new ModelAndView("/demo/index"); 
	} 
	 @RequestMapping(value="/indexGL",method=RequestMethod.GET)
	 public ModelAndView indexGL() {
			return new ModelAndView("/demo/indexGL"); 
		} 
	 @RequestMapping(value="/statistics",method=RequestMethod.GET)
	 public ModelAndView statistics() {
			return new ModelAndView("/demo/statistics"); 
		} 
	 @RequestMapping(value="/statistics01",method=RequestMethod.GET)
	 public ModelAndView statistics01() {
			return new ModelAndView("/demo/statistics01"); 
		} 
	 @RequestMapping(value="/userjsp",method=RequestMethod.GET)
	 public ModelAndView userjsp() {
		 return new ModelAndView("/demo/user"); 
	 } 
	 @RequestMapping(value="/modulejsp",method=RequestMethod.GET)
	 public ModelAndView modulejsp() {
		 return new ModelAndView("/demo/module"); 
	 } 
	 @RequestMapping(value="/rolejsp",method=RequestMethod.GET)
	 public ModelAndView rolejsp() {
		 return new ModelAndView("/demo/role"); 
	 } 
	 @RequestMapping(value="/followsjsp",method=RequestMethod.GET)
	 public ModelAndView followsjsp() {
		 return new ModelAndView("/demo/follows"); 
	 } 
	  
}
