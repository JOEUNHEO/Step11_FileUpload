package test.filter;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;

//모든 요청에 대해서 필터 동작 하도록 설정 ...(web.xml 에 설정 해 놓았음!!)

public class EncodingFilter implements Filter{
	//인코딩 정보를 저장할 멤버필드
	String encoding;
	
	@Override
	public void destroy() {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
			throws IOException, ServletException {
		//인코딩 설정이 되어 있지 않으면
		if(req.getCharacterEncoding() == null) {
			//인코딩 설정을 한다.
			req.setCharacterEncoding(encoding);
		}
		//다음 작업 수행하기
		chain.doFilter(req, res);
		
	}
		
	//필터가 최초 동작 될때 호출되는 메소드
	@Override
	public void init(FilterConfig config) throws ServletException {
		//메소드에 전달되는 config 객체에 초기화 정보가 전달된다.
		
		// web.xml 에 정의된 인코딩 정보를 읽어온다. (utf-8)
		encoding = config.getInitParameter("encoding");
		
	}

}
