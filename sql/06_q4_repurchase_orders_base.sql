/* ===============================
   Q4-1. 재구매 기간 분석용 데이터 생성 (주문 기준)
=================================
구매일과 주문 매출 정보를 포함한 주문 데이터 생성

- 배송 완료(delivered) 주문만 분석
- 상품가(price) 기준 주문 매출 집계
- 주문 1건 = 1행 기준으로 구성
*/

WITH order_revenue AS (
  -- 1. 주문별 매출 합계 계산
  SELECT
    oi.order_id,
    SUM(oi.price) AS order_revenue
  FROM order_items oi
  GROUP BY oi.order_id
)

-- 2. 고객ID, 구매일, 주문 매출을 결합한 주문 데이터 조회
SELECT
  c.customer_unique_id,
  o.order_id,
  DATE(o.order_purchase_timestamp) AS purchase_date,
  orv.order_revenue
FROM orders o
JOIN customers c
  ON o.customer_id = c.customer_id
JOIN order_revenue orv
  ON o.order_id = orv.order_id
WHERE o.order_status = 'delivered'
  AND o.order_purchase_timestamp IS NOT NULL;