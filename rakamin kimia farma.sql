DROP TABLE IF EXISTS kimia_farma.analisa;

CREATE TABLE kimia_farma.analisa AS
SELECT 
    t.transaction_id,
    t.date,
    t.branch_id,
    k.branch_name,
    k.kota,
    k.provinsi,
    k.rating AS rating_cabang,
    t.rating AS rating_transaksi,
    t.customer_name,
    t.product_id,
    i.product_name,
    t.price AS actual_price,
    t.discount_percentage,
    CASE 
        WHEN t.price <= 50000 THEN 0.10
        WHEN t.price <= 100000 THEN 0.15
        WHEN t.price <= 300000 THEN 0.20
        WHEN t.price <= 500000 THEN 0.25
        ELSE 0.30
    END AS persentase_gross_laba,
    (t.price - (t.price * t.discount_percentage)) AS nett_sales,
    ((t.price - (t.price * t.discount_percentage)) * 
        CASE 
            WHEN t.price <= 50000 THEN 0.10
            WHEN t.price <= 100000 THEN 0.15
            WHEN t.price <= 300000 THEN 0.20
            WHEN t.price <= 500000 THEN 0.25
            ELSE 0.30
        END) AS nett_profit
FROM 
    `kimia_farma.kf_final_transaction` AS t
LEFT JOIN 
    `kimia_farma.kf_inventory` AS i ON t.product_id = i.product_id
LEFT JOIN 
    `kimia_farma.kf_kantor_cabang` AS k ON t.branch_id = k.branch_id
WHERE 
    t.transaction_id IN (
        SELECT 
            transaction_id
        FROM 
            `kimia_farma.kf_final_transaction`
        GROUP BY 
            transaction_id
    );
