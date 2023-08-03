package com.spring.javaweb6S.service;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.stereotype.Service;
import org.springframework.transaction.TransactionDefinition;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.DefaultTransactionDefinition;

import com.spring.javaweb6S.dao.MemberDAO;
import com.spring.javaweb6S.dao.OrderDAO;
import com.spring.javaweb6S.vo.CartVO;
import com.spring.javaweb6S.vo.CouponVO;
import com.spring.javaweb6S.vo.OrderVO;

@Service
public class OrderServiceImpl implements OrderService {

	@Autowired
	DataSourceTransactionManager transactionManager;

	@Autowired
	OrderDAO orderDAO;

	@Override
	public int setNewOrder(OrderVO vo) {
		int res = 0;
		DefaultTransactionDefinition def = new DefaultTransactionDefinition();
		def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED);
		TransactionStatus status = transactionManager.getTransaction(def);
		String[] p_idx = vo.getProductList().split("/");
		String[] od_amount = vo.getAmountList().split("/");

		SimpleDateFormat format = new SimpleDateFormat("yyyyMMdd");
		Date tempDate = new Date(System.currentTimeMillis());

		String date = format.format(tempDate);

		try {
			orderDAO.setNewOrder(vo);
			orderDAO.setNewOrderDetail(vo, vo.getO_idx());
			orderDAO.setNewPaymentDetail(vo, vo.getO_idx());

			if (vo.getPay_point() != 0) {
				orderDAO.pointMinus(vo.getM_mid(), vo.getPay_point(), vo.getO_idx());
				orderDAO.minusMemberPoint(vo.getPay_point(), vo.getM_mid());
			}
			for (int i = 0; i < p_idx.length; i++) {
				UUID tempUid = UUID.randomUUID();
				String uid = tempUid.toString().substring(0, 4).toUpperCase();
				String productCode = "P" + date + uid;
				vo.setOi_productCode(productCode);

				orderDAO.setNewOrderItems(vo.getO_idx(), Integer.parseInt(p_idx[i]), Integer.parseInt(od_amount[i]),
						vo.getO_status(), vo.getOi_productCode());
				// 주문과정 완료 처리 후 해당 수량만큼 재고를 감소시켜야함
				orderDAO.setProductMinus(Integer.parseInt(p_idx[i]), Integer.parseInt(od_amount[i]));

				// 결제 완료시 카트에 들어있는 내역도 삭제해줘야 함
				List<CartVO> vos = orderDAO.getMemberCart(vo.getM_mid());
				for (CartVO cart : vos) {
					if (cart.getP_idx() == Integer.parseInt(p_idx[i])) {
						orderDAO.deleteCart(Integer.parseInt(p_idx[i]), cart.getM_mid());
					}
				}
			}

			// 사용한 쿠폰을 사용처리 해줘야함
			orderDAO.setCouponUse(vo.getCu_idx());

			transactionManager.commit(status);
			res = 1;
		} catch (Exception e) {
			transactionManager.rollback(status);
			throw e;
		}

		return res;
	}

	@Override
	public List<CartVO> getMemberCart(String m_mid) {
		return orderDAO.getMemberCart(m_mid);
	}

	@Override
	public int setMemberCart(CartVO vo) {
		return orderDAO.setMemberCart(vo);
	}

	@Override
	public int updateMemberCart(CartVO vo) {
		// TODO Auto-generated method stub
		return orderDAO.updateMemberCart(vo);
	}

	@Override
	public void deleteCart(int p_idx, String sMid) {
		orderDAO.deleteCart(p_idx, sMid);
	}

	@Override
	public OrderVO getOrderCode(String o_orderCode) {
		return orderDAO.getOrderCode(o_orderCode);
	}

	@Override
	public int updateOrderStatus(String oi_productCode, String status) {
		return orderDAO.updateOrderStatus(oi_productCode, status);
	}

	@Override
	public int updateMemberPoint(String oi_productCode, int totalPrice, int ratio, String sMid) {

		int res = 0;
		DefaultTransactionDefinition def = new DefaultTransactionDefinition();
		def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED);
		TransactionStatus status = transactionManager.getTransaction(def);

		try {
			// 상태를 구매확정으로 바꿔주고
			orderDAO.updateOrderStatus(oi_productCode, "구매확정");
			// 상품의 금액만큼 포인트를 적립해준다
			int point = (int) (totalPrice * (ratio * 0.01));
			orderDAO.pointHistory(sMid, point, oi_productCode);
			System.out.println(point);
			orderDAO.updateMemberPoint(point, sMid);
			transactionManager.commit(status);
			res = 1;
		} catch (Exception e) {
			transactionManager.rollback(status);
			throw e;
		}

		return res;
	}

	@Override
	public int getCouponUse(int o_idx, int price) {
		CouponVO vo = orderDAO.getCouponUse(o_idx);
		int salePrice = 0;
		if (vo != null) {
			System.out.println(vo);
			if (vo.getCp_type() == 1) {
				// 정율
				salePrice = (int) (price * vo.getCp_ratio() * 0.01);
			} else {
				// 정액
				salePrice = vo.getCp_price();
			}
		}
		return salePrice;
	}

}
