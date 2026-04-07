/* ===============================
   Q2-1. 상위 매출 상품의 매출 비중 분석
=================================
- 배송 완료(delivered) 주문만 분석
- 상품(product_id)별 매출(price) 집계
- 전체 매출 대비 상위 10개 상품 매출 비중(%) 계산
*/

WITH base AS (
  SELECT
    oi.product_id,
    -- 1. 상품별 매출 합계 계산
    SUM(oi.price) AS revenue
  FROM order_items oi
  JOIN orders o
    ON oi.order_id = o.order_id
  WHERE o.order_status = 'delivered'
  GROUP BY oi.product_id
),

ranked AS (
  -- 2. 상품별 매출 순위 생성
  SELECT
    product_id,
    revenue,
    -- 매출 기준 내림차순 순위 (동순위 허용)
    DENSE_RANK() OVER (ORDER BY revenue DESC) AS rnk
  FROM base
),

tot AS (
  -- 3. 전체 매출 합계 계산
  SELECT SUM(revenue) AS total_revenue
  FROM base
),

topn AS (
  -- 4. 상위 10개 상품 매출 합계 계산
  SELECT SUM(revenue) AS topn_revenue
  FROM ranked
  WHERE rnk <= 10
)

-- 5. 상위 10개 상품 매출과 매출 비중 계산
SELECT
  topn.topn_revenue,
  tot.total_revenue,
  ROUND(topn.topn_revenue / tot.total_revenue, 4) AS topn_share_ratio
FROM topn
CROSS JOIN tot;