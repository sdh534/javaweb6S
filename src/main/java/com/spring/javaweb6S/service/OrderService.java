package com.spring.javaweb6S.service;

import java.util.List;

import com.spring.javaweb6S.vo.CartVO;
import com.spring.javaweb6S.vo.OrderVO;

public interface OrderService {

	public int setNewOrder(OrderVO vo);

	public List<CartVO> getMemberCart(String m_mid);

	public int setMemberCart(CartVO vo);

	public int updateMemberCart(CartVO vo);

	public void deleteCart(int p_idx, String sMid);

	public OrderVO getOrderCode(String o_orderCode);

	public int updateOrderStatus(String oi_productCode, String status);

	public int updateMemberPoint(String oi_productCode, int totalPrice, int ratio, String sMid);

	public int getCouponUse(int o_idx, int price);

}
