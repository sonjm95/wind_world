package com.wind_world.back.Controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestMapping;
@CrossOrigin(origins = { "*" }, maxAge = 6000)
@Controller
@RequestMapping("/move")



public class MainController {
   @RequestMapping("/mvmain")
   public String mvmain() {
      System.out.println("메인페이지로 이동");
      return "index";
   }
}
