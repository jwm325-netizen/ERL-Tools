CREATE OR REPLACE Table [YourSchema].agreement_cost_fy

AS SELECT sa.sa_name,

    ent.ent_reference AS "KBID",

    ent.ent_description AS "Title / Package Name / Description",

    ent.ent_note AS "Notes",

    jsonb_extract_path_text(pol.jsonb, VARIADIC ARRAY['poLineNumber'::text]) AS "PO-Line",

    jsonb_extract_path_text(pol.jsonb, VARIADIC ARRAY['fundDistribution'::text, '0'::text, 'code'::text]) AS "Fund Code",

    sum(

        CASE

            WHEN jsonb_extract_path_text(fy.jsonb, VARIADIC ARRAY['code'::text]) = 'FY2021'::text THEN jsonb_extract_path_text(inv.jsonb, VARIADIC ARRAY['total'::text])::numeric

            ELSE 0::numeric

        END) AS "FY2021",

    sum(

        CASE

            WHEN jsonb_extract_path_text(fy.jsonb, VARIADIC ARRAY['code'::text]) = 'FY2022'::text THEN jsonb_extract_path_text(inv.jsonb, VARIADIC ARRAY['total'::text])::numeric

            ELSE 0::numeric

        END) AS "FY2022",

    sum(

        CASE

            WHEN jsonb_extract_path_text(fy.jsonb, VARIADIC ARRAY['code'::text]) = 'FY2023'::text THEN jsonb_extract_path_text(inv.jsonb, VARIADIC ARRAY['total'::text])::numeric

            ELSE 0::numeric

        END) AS "FY2023",

    sum(

        CASE

            WHEN jsonb_extract_path_text(fy.jsonb, VARIADIC ARRAY['code'::text]) = 'FY2024'::text THEN jsonb_extract_path_text(inv.jsonb, VARIADIC ARRAY['total'::text])::numeric

            ELSE 0::numeric

        END) AS "FY2024",

    sum(

        CASE

            WHEN jsonb_extract_path_text(fy.jsonb, VARIADIC ARRAY['code'::text]) = 'FY2025'::text THEN jsonb_extract_path_text(inv.jsonb, VARIADIC ARRAY['total'::text])::numeric

            ELSE 0::numeric

        END) AS "FY2025",

    sum(

        CASE

            WHEN jsonb_extract_path_text(fy.jsonb, VARIADIC ARRAY['code'::text]) = 'FY2026'::text THEN jsonb_extract_path_text(inv.jsonb, VARIADIC ARRAY['total'::text])::numeric

            ELSE 0::numeric

        END) AS "FY2026"

   FROM folio_agreements.subscription_agreement sa

     LEFT JOIN folio_agreements.entitlement ent ON sa.sa_id = ent.ent_owner_fk

     LEFT JOIN folio_agreements.order_line ol ON ent.ent_id = ol.pol_owner_fk

     LEFT JOIN folio_orders.po_line pol ON ol.pol_orders_fk = pol.id

     LEFT JOIN folio_invoice.invoice_lines inv ON jsonb_extract_path_text(pol.jsonb, VARIADIC ARRAY['id'::text]) = jsonb_extract_path_text(inv.jsonb, VARIADIC ARRAY['poLineId'::text])

     LEFT JOIN folio_finance.transaction trans ON jsonb_extract_path_text(inv.jsonb, VARIADIC ARRAY['id'::text]) = jsonb_extract_path_text(trans.jsonb, VARIADIC ARRAY['sourceInvoiceLineId'::text])

     LEFT JOIN folio_finance.fiscal_year fy ON jsonb_extract_path_text(trans.jsonb, VARIADIC ARRAY['fiscalYearId'::text]) = jsonb_extract_path_text(fy.jsonb, VARIADIC ARRAY['id'::text])

  GROUP BY sa.sa_name, ent.ent_reference, ent.ent_description, ent.ent_note, (jsonb_extract_path_text(pol.jsonb, VARIADIC ARRAY['poLineNumber'::text])), (jsonb_extract_path_text(pol.jsonb, VARIADIC ARRAY['fundDistribution'::text, '0'::text, 'code'::text]));

