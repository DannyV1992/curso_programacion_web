import mysql.connector

db = mysql.connector.connect(
    host="localhost",
    port=3306,
    user="root",
    password="root",
    database="crm_leads"
)
print("¡Conexión exitosa!")
db.close()
