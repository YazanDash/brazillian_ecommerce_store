SELECT
    geolocation_lat,
    geolocation_lng
FROM dbo.olist_geolocation_dataset
WHERE
    (
        NULLIF(LTRIM(RTRIM(geolocation_lat)), '') IS NOT NULL
        AND TRY_CONVERT(decimal(18,12), geolocation_lat) IS NULL
    )
    OR
    (
        NULLIF(LTRIM(RTRIM(geolocation_lng)), '') IS NOT NULL
        AND TRY_CONVERT(decimal(18,12), geolocation_lng) IS NULL
    );



    SELECT
    geolocation_zip_code_prefix,

    TRY_CONVERT(
        decimal(18,12),
        NULLIF(LTRIM(RTRIM(geolocation_lat)), '')
    ) AS geolocation_lat,

    TRY_CONVERT(
        decimal(18,12),
        NULLIF(LTRIM(RTRIM(geolocation_lng)), '')
    ) AS geolocation_lng,

    geolocation_city,
    geolocation_state

INTO dbo.geolocation_clean
FROM dbo.olist_geolocation_dataset;


SELECT TOP (20) *
FROM dbo.geolocation_clean;