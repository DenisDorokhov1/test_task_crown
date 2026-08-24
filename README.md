# БД «Тендерная площадка»

## Реализованные таблицы:
- компании, размещающие тендер - **companies**
- заявка на тендер от компаний - **tenders**
- лоты на тендеры - **lots**
- потенциальные исполнители контрактов - **contractor**
- ставки на лоты - **bids**

## Логика связей

- Компания может создавать несколько тендеров.
- Тендер может содержать несколько лотов.
- На каждый лот исполнители могут подавать ставки.
- Один исполнитель может участвовать в нескольких лотах.

Запросы: 

1) Вывести топ-3 компаний по сумме выигранных тендеров за последний месяц
Условимся, что выигранный тендер обозначает ``` status="won" ``` и считаем общую сумму тендеров с таким статусом.

``` bash
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
```

2) Вывести топ лотов, где победителю удалось снизить цену относительно начальной стоимости лота сильнее всего.

```  bash
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
```