package com.tobo.dumo;

import java.text.DateFormat;
import java.util.Date;
import java.util.Locale;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.tobo.dumo.service.DumoService;

/**
 * Handles requests for the application home page.
 */
@Controller
public class HomeController {
	
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	
	@Resource(name="dumoService")
	private DumoService dumoService;

	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home(Locale locale, Model model) {
		
		// DB 서비스 불러서 가져옴 -> 게임 시작버튼을 누르면 가져오게 할까
		
		return "home";
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
