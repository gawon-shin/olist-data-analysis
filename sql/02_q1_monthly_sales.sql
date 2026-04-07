/* ===============================
   Q1. 월별 주문 수, 매출, 평균 객단가(AOV) 분석
=================================
- 배송 완료(delivered) 주문만 분석
- 구매일을 YYYY-MM로 변환하여 월 단위 집계
*/

SELECT
    DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS order_month,
    COUNT(DISTINCT o.order_id) AS order_count,
    SUM(oi.price) AS total_revenue,
    -- AOV 계산, 0으로 나누는 경우 방지
    ROUND(
        SUM(oi.price) / NULLIF(COUNT(DISTINCT o.order_id), 0),
        2
    ) AS aov
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
  AND o.order_purchase_timestamp IS NOT NULL
GROUP BY order_month
ORDER BY order_month;