-- Generated by Oracle SQL Developer Data Modeler 19.1.0.081.0911
--   at:        2019-06-14 22:21:08 CEST
--   site:      Oracle Database 11g
--   type:      Oracle Database 11g



CREATE user bd2a01 identified by account unlock 
;

CREATE TABLE luki (
    id_luku     NUMBER(5) NOT NULL,
    nazwa       VARCHAR2(30),
    dlugosc     NUMBER(9, 3) NOT NULL,
    id_wezla1   NUMBER(5) NOT NULL,
    id_sieci1   NUMBER(5) NOT NULL,
    id_wezla2   NUMBER(5) NOT NULL,
    id_sieci2   NUMBER(5) NOT NULL
)
LOGGING;

COMMENT ON TABLE luki IS
    '�uk ��cz�cy dwa w�z�y w sieci';

COMMENT ON COLUMN luki.dlugosc IS
    'd�ugo�� �uku ��cz�cego dwa w�z�y w km, z dok�adno�ci� do 3 miejsc po przecinku.';

COMMENT ON COLUMN luki.id_wezla1 IS
    'ID w�z�a, kt�ry jest pocz�tkiem �uku';

COMMENT ON COLUMN luki.id_sieci1 IS
    'ID Sieci, do kt�rej nale�y pocz�tkowy w�ze� �uku';

COMMENT ON COLUMN luki.id_wezla2 IS
    'ID w�z�a, kt�ry jest ko�cem �uku';

COMMENT ON COLUMN luki.id_sieci2 IS
    'ID sieci, do kt�rej nale�y ko�cowy w�ze� �uku';

CREATE INDEX luki__idx_wez1 ON
    luki (
        id_wezla1
    ASC,
        id_sieci1
    ASC )
        LOGGING;

CREATE INDEX luki__idx_wez2 ON
    luki (
        id_wezla2
    ASC,
        id_sieci2
    ASC )
        LOGGING;

GRANT SELECT, INSERT, UPDATE, DELETE ON luki TO bd2a01_app;

ALTER TABLE luki ADD CONSTRAINT luki_pk PRIMARY KEY ( id_luku );

CREATE TABLE oferty (
    id_oferty                   NUMBER(5) NOT NULL,
    ilosc_towaru                NUMBER(5) NOT NULL,
    miara                       VARCHAR2(15) NOT NULL,
    cena_za_jednostke_miary     NUMBER(9, 2) NOT NULL,
    startowa_data_dostepnosci   DATE NOT NULL,
    koncowa_data_dostepnosci    DATE,
    id_wezla                    NUMBER(5),
    id_sieci                    NUMBER(5),
    id_towaru                   NUMBER(5) NOT NULL,
    id_luku                     NUMBER(5)
)
LOGGING;

ALTER TABLE oferty
    ADD CONSTRAINT arc_2 CHECK ( ( ( id_luku IS NOT NULL )
                                   AND ( id_sieci IS NULL )
                                   AND ( id_wezla IS NULL ) )
                                 OR ( ( id_sieci IS NOT NULL )
                                      AND ( id_wezla IS NOT NULL )
                                      AND ( id_luku IS NULL ) ) );

COMMENT ON TABLE oferty IS
    'oferta zawarta w konkretnym w�le sieci fizycznej lub wirtualnej albo na jej konkretnym �uku';

COMMENT ON COLUMN oferty.miara IS
    'miara, w kt�rej podajemy ilo�� towaru (np. kWh)';

COMMENT ON COLUMN oferty.id_wezla IS
    'ID w�z�a sieci fizycznej lub wirtualnej, na kt�rym oferowany jest towar';

COMMENT ON COLUMN oferty.id_sieci IS
    'ID sieci, w kt�rej znajduje si� w�ze� lub �uk z ofert�';

COMMENT ON COLUMN oferty.id_towaru IS
    'ID towaru, kt�rego dotyczy oferta';

COMMENT ON COLUMN oferty.id_luku IS
    'ID �uku, na kt�rym oferowany jest towar';

CREATE INDEX oferty__idx_towar ON
    oferty (
        id_towaru
    ASC )
        LOGGING;

CREATE INDEX oferty__idx_luk ON
    oferty (
        id_luku
    ASC )
        LOGGING;

CREATE INDEX oferty__idx_wezel ON
    oferty (
        id_wezla
    ASC,
        id_sieci
    ASC )
        LOGGING;

GRANT SELECT, UPDATE, INSERT, DELETE ON oferty TO bd2a01_app;

ALTER TABLE oferty ADD CONSTRAINT oferty_pk PRIMARY KEY ( id_oferty );

CREATE TABLE sieci (
    id_sieci   NUMBER(5) NOT NULL,
    nazwa      VARCHAR2(30) NOT NULL,
    typ        VARCHAR2(30)
)
LOGGING;

COMMENT ON TABLE sieci IS
    'sie� przesy�owa, modelowana jako graf';

COMMENT ON COLUMN sieci.typ IS
    'fizyczna/wirtualna';

GRANT SELECT, INSERT, UPDATE, DELETE ON sieci TO bd2a01_app;

ALTER TABLE sieci ADD CONSTRAINT sieci_pk PRIMARY KEY ( id_sieci );

CREATE TABLE towary (
    id_towaru   NUMBER(5) NOT NULL,
    nazwa       VARCHAR2(30) NOT NULL,
    rodzaj      VARCHAR2(30)
)
LOGGING;

COMMENT ON COLUMN towary.rodzaj IS
    'np. energia, prawa przesy�u itp.';

GRANT SELECT, UPDATE, INSERT, DELETE ON towary TO bd2a01_app;

ALTER TABLE towary ADD CONSTRAINT towary_pk PRIMARY KEY ( id_towaru );

CREATE TABLE wezly (
    id_wezla                     NUMBER(5) NOT NULL,
    nazwa                        VARCHAR2(30),
    id_sieci                     NUMBER(5) NOT NULL,
    id_wezla_grupowanego         NUMBER(5),
    id_sieci_wezla_grupowanego   NUMBER(5)
)
LOGGING;

COMMENT ON TABLE wezly IS
    'w�z�y sieci przesy�owej';

COMMENT ON COLUMN wezly.id_wezla_grupowanego IS
    'w�z�y sieci wirtualnych powstaj� w wyniku grupowania w�z��w sieci fizycznej lub sieci wirtualnej o ni�szym stopniu agregacji'
    ;

COMMENT ON COLUMN wezly.id_sieci_wezla_grupowanego IS
    'numer sieci, do kt�rej nale�y w�ze� grupowany';

GRANT SELECT, INSERT, UPDATE, DELETE ON wezly TO bd2a01_app;

ALTER TABLE wezly ADD CONSTRAINT wezly_pk PRIMARY KEY ( id_sieci,
                                                        id_wezla );

ALTER TABLE luki
    ADD CONSTRAINT luki_wezly_fk FOREIGN KEY ( id_sieci1,
                                               id_wezla1 )
        REFERENCES wezly ( id_sieci,
                           id_wezla )
            ON DELETE CASCADE
    DEFERRABLE;

ALTER TABLE luki
    ADD CONSTRAINT luki_wezly_fk2 FOREIGN KEY ( id_sieci2,
                                                id_wezla2 )
        REFERENCES wezly ( id_sieci,
                           id_wezla )
            ON DELETE CASCADE
    DEFERRABLE;

ALTER TABLE oferty
    ADD CONSTRAINT oferty_luki_fk FOREIGN KEY ( id_luku )
        REFERENCES luki ( id_luku )
    DEFERRABLE;

ALTER TABLE oferty
    ADD CONSTRAINT oferty_towary_fk FOREIGN KEY ( id_towaru )
        REFERENCES towary ( id_towaru )
            ON DELETE CASCADE
    DEFERRABLE;

ALTER TABLE oferty
    ADD CONSTRAINT oferty_wezly_fk FOREIGN KEY ( id_sieci,
                                                 id_wezla )
        REFERENCES wezly ( id_sieci,
                           id_wezla )
    DEFERRABLE;

ALTER TABLE wezly
    ADD CONSTRAINT wezly_sieci_fk FOREIGN KEY ( id_sieci )
        REFERENCES sieci ( id_sieci )
            ON DELETE CASCADE
    DEFERRABLE;

ALTER TABLE wezly
    ADD CONSTRAINT wezly_wezly_fk FOREIGN KEY ( id_wezla_grupowanego,
                                                id_sieci_wezla_grupowanego )
        REFERENCES wezly ( id_sieci,
                           id_wezla )
    DEFERRABLE;

CREATE OR REPLACE TRIGGER fkntm_luki BEFORE
    UPDATE OF id_sieci2, id_wezla2, id_sieci1, id_wezla1 ON luki
BEGIN
    raise_application_error(-20225, 'Non Transferable FK constraint  on table LUKI is violated');
END;
/

CREATE OR REPLACE TRIGGER fkntm_oferty BEFORE
    UPDATE OF id_towaru ON oferty
BEGIN
    raise_application_error(-20225, 'Non Transferable FK constraint  on table OFERTY is violated');
END;
/

CREATE OR REPLACE TRIGGER fkntm_wezly BEFORE
    UPDATE OF id_sieci ON wezly
BEGIN
    raise_application_error(-20225, 'Non Transferable FK constraint  on table WEZLY is violated');
END;
/



-- Oracle SQL Developer Data Modeler Summary Report: 
-- 
-- CREATE TABLE                             5
-- CREATE INDEX                             5
-- ALTER TABLE                             13
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           3
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          0
-- CREATE MATERIALIZED VIEW                 0
-- CREATE MATERIALIZED VIEW LOG             0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              1
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- REDACTION POLICY                         0
-- 
-- ORDS DROP SCHEMA                         0
-- ORDS ENABLE SCHEMA                       0
-- ORDS ENABLE OBJECT                       0
-- 
-- ERRORS                                   0
-- WARNINGS                                 0
