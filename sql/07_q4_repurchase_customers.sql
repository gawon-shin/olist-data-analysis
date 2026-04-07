/* ===============================
   Q4-2. 재구매 고객 분석용 데이터 생성 (고객 기준)
=================================
고객별 주문 수와 총매출을 포함한 집계 데이터 생성

- 배송 완료(delivered) 주문만 분석
- 상품가(price) 기준 주문 매출 집계
- customer_unique_id 기준 고객 단위 집계
*/

WITH order_revenue AS (
  -- 1. 주문별 매출 합계 계산
  SELECT
    oi.order_id,
    SUM(oi.price) AS order_revenue
  FROM order_items oi
  GROUP BY oi.order_id
),

order_fact AS (
  -- 2. 고객별 주문 이력과 주문 매출 결합
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
)

-- 3. 고객별 주문 수, 총매출, 재구매 여부 집계
SELECT
  customer_unique_id,
  COUNT(DISTINCT order_id) AS order_cnt,
  COUNT(DISTINCT purchase_date) AS purchase_day_cnt,
  SUM(order_revenue) AS total_revenue,
  CASE 
    WHEN COUNT(DISTINCT purchase_date) >= 2 THEN 1 
    ELSE 0 
  END AS is_repeat    -- 재구매 여부 (1: 재구매, 0: 1회 구매)
FROM order_fact
GROUP BY customer_unique_id;


