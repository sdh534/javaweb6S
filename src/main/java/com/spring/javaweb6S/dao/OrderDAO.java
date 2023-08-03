package com.spring.javaweb6S.dao;

import java.util.ArrayList;
import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.spring.javaweb6S.vo.CartVO;
import com.spring.javaweb6S.vo.CouponVO;
import com.spring.javaweb6S.vo.OrderVO;

public interface OrderDAO {

	public int setNewOrder(@Param("vo") OrderVO vo);

	public void setNewOrderDetail(@Param("vo") OrderVO vo, @Param("o_idx") int o_idx);

	public void setNewPaymentDetail(@Param("vo") OrderVO vo, @Param("o_idx") int o_idx);

	public List<CartVO> getMemberCart(@Param("m_mid") String m_mid);

	public int setMemberCart(@Param("vo") CartVO vo);

	public int updateMemberCart(@Param("vo") CartVO vo);

	public void deleteCart(@Param("p_idx") int p_idx, @Param("sMid") String sMid);

	public void setNewOrderItems(@Param("o_idx") int o_idx, @Param("p_idx") int p_idx, @Param("od_amount") int od_amount,
			@Param("o_status") String o_status, @Param("oi_productCode") String oi_productCode);

	public OrderVO getOrderCode(@Param("o_orderCode") String o_orderCode);

	public void setProductMinus(@Param("p_idx") int p_idx, @Param("od_amount") int od_amount);

	public void updateCSstatus(@Param("o_cStatus") String o_cStatus, @Param("o_idx") int o_idx);

	public void setCouponUse(@Param("cu_idx") int cu_idx);

	public int updateOrderStatus(@Param("oi_productCode") String oi_productCode, @Param("status") String status);

	public void updateMemberPoint(@Param("point") int point, @Param("sMid") String sMid);

	public CouponVO getCouponUse(@Param("o_idx") int o_idx);

	public void updatePayPrice(@Param("refundPrice") int refundPrice, @Param("o_idx") int o_idx);

	public ArrayList<String> getPaidStatus(@Param("o_status") String o_status);

	public String getImp_uid(@Param("imp_uid") String imp_uid);

	public void pointHistory(@Param("mid") String sMid, @Param("point") int point,
			@Param("oi_productCode") String oi_productCode);

	public void pointMinus(@Param("mid") String sMid, @Param("point") int point, @Param("o_idx") int o_idx);

	public void minusMemberPoint(@Param("point") int pay_point, @Param("m_mid") String m_mid);

}
