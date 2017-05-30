package com.tobo.dumo;

import java.text.DateFormat;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;
import javax.inject.Inject;
import javax.inject.Named;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.tobo.dumo.service.DumoService;


@Controller
public class HomeController{
	
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	
	//@Resource(name="dumoService")
	@Inject
	@Named("dumoService")
	private DumoService dumoService;

	@RequestMapping(value = "/", method = RequestMethod.GET)
	public ModelAndView home(Map<String,Object> commandMap) throws Exception { //Locale locale, Model model
		ModelAndView mv = new ModelAndView();
		
		// DB 서비스 불러서 가져옴 -> 게임 시작버튼을 누르면 가져오게 할까
		List<Map<String,Object>> list = dumoService.selectWordList(commandMap);
		
		mv.setViewName("home"); // 뷰 이름 설정
		mv.addObject("word",list); // 보낼데이터 넣어주기
		return mv;
	}
	
	// 데이터 넣을 때
	@ResponseBody
	public String getWordDB(){
		// 넣어진 게임 단어는 다음 게임 플레이시부터 사용가능하다
		return null;
	}
	
	@RequestMapping(value = "/gamePr", method = RequestMethod.GET)
	public String goToGame(Locale locale, Model model) {
		return "gamePr";
	}
	
}
