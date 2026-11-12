-- ============================================================
-- STUDI KASUS 2: CUSTOMER SEGMENTATION MENGGUNAKAN RFM (ONLINE RETAIL)
-- ============================================================

-- Langkah 1: Membuat CTE untuk menghitung nilai dasar RFM dari tabel transaksi
WITH rfm_raw AS (
SELECT
        customerid,
        -- Recency: Berapa hari sejak transaksi terakhir pelanggan (asumsi tanggal referensi max date dari data + 1 hari)
        (DATE '2011-12-10' - MAX(invoicedate::DATE)) AS recency_days,
        -- Frequency: berapa kali pelanggan melakukan transaksi unik
        COUNT(DISTINCT invoiceno) AS frequency_count,
        -- Monetary: Total uang yang dibelanjakan pelanggan
        SUM(quantity * unitprice) AS monetary_value
FROM supermarketsales
WHERE customerid is not null
GROUP BY customerid
),

-- Langkah 2: Memberikan skor (skala 1 sampai 4) menggunakan NTILE window function
rfm_scores AS (
SELECT
	customerid,
	recency_days,
	frequency_count,
	monetary_value,
	NTILE(4) OVER (ORDER BY recency_days DESC) AS r_score,
	NTILE(4) OVER (ORDER BY frequency_count ASC) AS f_score,
	NTILE(4) OVER (ORDER BY monetary_value ASC) AS m_score
	FROM rfm_raw
),

-- Lanhkah 3: Menggabungkan skor dan menentukan kategori segmentasi pelanggan
rfm_final AS ( 
SELECT 
	customerid,
	recency_days,
	frequency_count,
	monetary_value,
	(r_score + f_score + m_score) AS rfm_total_score,
	CASE
		WHEN (r_score + f_score + m_score) >= 10 THEN 'Champions / Pelanggan setia'
		WHEN (r_score + f_score + m_score) >= 7 THEN 'Potential Loyalist'
		WHEN (r_score + f_score + m_score) >= 4 THEN 'At Risk / Perlu Perhatian'
		ELSE 'Lost Customer'
	END AS customer_segment
FROM rfm_scores
)

-- Langkah 4: Menampilkan hasil akhir rangkuman segmentasi
SELECT
	customer_segment,
	COUNT(customerid) AS total_customer,
	ROUND(AVG(monetary_value), 2) AS avg_monetary_spent
FROM rfm_final
GROUP BY customer_segment
ORDER BY avg_monetary_spent DESC;
