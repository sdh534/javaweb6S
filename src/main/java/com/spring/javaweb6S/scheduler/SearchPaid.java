package com.spring.javaweb6S.scheduler;

import java.io.IOException;
import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.siot.IamportRestClient.IamportClient;
import com.siot.IamportRestClient.exception.IamportResponseException;
import com.siot.IamportRestClient.response.Payment;
import com.spring.javaweb6S.dao.OrderDAO;

@Component
public class SearchPaid {
	@Autowired
	OrderDAO orderDAO;

	// 10분마다 실행, 아임 포트
	@Scheduled(cron = "0 0/10 * * * ?")
	// @Scheduled(cron = "*/10 * * * * *")
	public void search() {
		IamportClient client = new IamportClient("5074657238861441",
				"API키값");

		ArrayList<String> imp_uids = orderDAO.getPaidStatus("결제대기");
		for (String imp_uid : imp_uids) {
			try {
				Payment res = client.paymentByImpUid(imp_uid).getResponse();
				System.out.println(res.getStatus());
				if (res.getStatus().equals("paid")) {
					String o_orderCode = orderDAO.getImp_uid(imp_uid);
					System.out.println(o_orderCode); 
					orderDAO.updateOrderStatus(o_orderCode, "결제완료");
					System.out.println(imp_uid + "건의 결제가 완료되었습니다.");
				}
			} catch (IamportResponseException e) {
				System.out.println(e.getMessage());
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
			}

		}
	}
}
