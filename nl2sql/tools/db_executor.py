import pymysql


def get_connerction():
    connection = pymysql.connect(
        host='',
        port='',
        user='',
        password='',
        db='',
        charset=''
    )
    return connection


def validate_sql(generated_query) -> tuple[bool, str]:
    """
    생성된 SQL 질의문이 문법적으로 올바른지,
    존재하는 테이블/컬럼을 참조하는지 검증
    """
    keywords = ["INSERT","UPDATE","DELETE","DROP"]

    if not generated_query:
        return False, "쿼리가 생성되지 않았습니다."

    if not generated_query.strip().upper().startswith("SELECT", "WITH"):
        return False, "오류: SELECT 또는 WITH 로 시작하는 쿼리만 허용됩니다."

    if any(word in generated_query for word in keywords):
        return False, "DB를 변경하는 명령어가 포함되어 있습니다."

    try:
        conn = get_connerction()
        with conn.cursor() as cursor:
            cursor.execute("EXPLAIN " + generated_query)

        conn.close()
        return True, ""
    except pymysql.Error as e:
        return False, f"SQL문 실행오류: {type(e).__name__}: {e}"
        
