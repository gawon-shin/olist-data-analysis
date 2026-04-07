/* ===============================
   Q3. 배송 소요 시간 및 지연 분석
=================================
- 배송 완료(delivered) 주문만 분석
- 주문 1건 = 1행 기준 구성
*/

SELECT
    o.order_id,
    o.customer_id,
    o.order_purchase_timestamp,
    o.order_delivered_customer_date,
    o.order_estimated_delivery_date,
    -- 배송 소요 일수 = 실제 배송완료일 - 구매일
    DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp) AS delivery_days,
    
    -- 배송 지연 여부 (1: 지연, 0: 정상)
    CASE
        WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date THEN 1
        ELSE 0
    END AS is_late,
    
    -- 지연 일수(지연인 경우만 계산)
    CASE
        WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date
            THEN DATEDIFF(o.order_delivered_customer_date, o.order_estimated_delivery_date)
        ELSE 0
    END AS late_days
    
FROM orders o
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
  AND o.order_purchase_timestamp IS NOT NULL
  AND o.order_estimated_delivery_date IS NOT NULL;
