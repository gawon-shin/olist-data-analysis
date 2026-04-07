/* ===============================
   Q2-2. 카테고리별 매출 비중
=================================
- 배송 완료(delivered) 주문만 분석
- 카테고리별 매출(상품가 기준) 집계
- 전체 매출 대비 카테고리 매출 비중(%) 계산
*/

WITH cat_base AS (
   -- 1. 카테고리별 매출 합계 계산
  SELECT
    -- 카테고리 결측/공백은 'unknown'으로 통일
    COALESCE(NULLIF(TRIM(p.product_category_name), ''), 'unknown') AS category,
    SUM(oi.price) AS revenue
  FROM order_items oi
  JOIN orders o 
    ON oi.order_id = o.order_id
  JOIN products p 
    ON oi.product_id = p.product_id
  WHERE o.order_status = 'delivered'
  GROUP BY COALESCE(NULLIF(TRIM(p.product_category_name), ''), 'unknown')
),

tot AS (
  -- 2. 전체 매출 합계 계산
  SELECT SUM(revenue) AS total_revenue
  FROM cat_base
)

-- 3. 카테고리별 매출과 매출 비중 계산
SELECT
  category,
  revenue,
  ROUND(revenue / tot.total_revenue, 4) AS category_share_ratio
FROM cat_base
CROSS JOIN tot
ORDER BY revenue DESC;
