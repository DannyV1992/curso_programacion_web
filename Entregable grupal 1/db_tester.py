import mysql.connector

db = mysql.connector.connect(
    host="localhost",
    port=3306,
    user="root",
    password="root",
    database="manufacturing_logs"
)
print("¡Conexión exitosa!")
db.close()

'''
import mysql.connector

db = mysql.connector.connect(
    host="localhost",
    port=3306,
    user="root",
    password="123Queso.",
    database="manufacturing_logs"
)
cursor = db.cursor()
cursor.execute("INSERT INTO tech_logs (email, task, subtask, started_at, end_at, comentario) VALUES ('test@test.com', 'Mantenimiento', 'Lubricación', '2025-06-26T14:00:00', '2025-06-26T14:30:00', 'TEST')")
db.commit()
cursor.close()
db.close()
'''