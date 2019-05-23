package com.dyz.service;

import java.util.List;

import javax.servlet.http.HttpSession;

import com.dyz.entity.Askers;
import com.dyz.entity.Student;

public interface FenLiangService {
	/**
	 * 查询咨询师
	 * @return
	 */
	List<Askers> selectzixunname();
	
	/**
	 * 查询所有没有咨询师跟踪的学生
	 * @return
	 */
	List<Student> selectStuByZiXunName();
	
	
	
	void fenliang(HttpSession session) ;
	/**
	 * 
	 * @param userChecksId
	 * @return查询手里的学生数
	 */
	Integer selectAskerStu_count(int userChecksId);
	
}
