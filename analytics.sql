SELECT
    c.id,
    c.name,
    SUM(b.amount) AS total_won_amount
FROM companies c
JOIN tenders t
    ON t.company_id = c.id
JOIN lots l
    ON l.tender_id = t.id
JOIN bids b
    ON b.lot_id = l.id
WHERE b.status = 'won'
  AND b.created_at >= CURRENT_TIMESTAMP - INTERVAL '1 month'
GROUP BY c.id, c.name
ORDER BY total_won_amount DESC
LIMIT 3;


SELECT
    l.id,
    l.title,
    l.initial_price,
    b.amount AS winning_amount,
    l.initial_price - b.amount AS saving,
    ROUND(
        (l.initial_price - b.amount) / l.initial_price * 100,
        2
    ) AS saving_percent
FROM lots l
JOIN bids b
    ON b.lot_id = l.id
WHERE b.status = 'won'
ORDER BY saving_percent DESC
LIMIT 10;