# PortfolioProjects

All of the Fixes I Have Found That Helped Me Complete This 2021 Project in 2023:

Server Issue:
1. After downloading SSMS you have to download the server file "SQL2022-SSEI-Expr.
2. Run the .exe and select basic installation. Wait until all download bars are completely finished.
3. When it has completed you will see a screen saying "Express Edition Installation has been completed successfully!" It will also list the Instance Name, SQL Administrators, Features Installed, and Version. 
4. You do NOT need to click "connect." You can just close this window.
5. Open SSMS (the first download).
6. Find the server name box before trying to connect.
7. Select the drop-down menu -- click "Database Engine" -- select whatever pops up. Example: "desktop-RandomNumbers\SQLEXPRESS"
8. BEFORE hitting connect.... copy the server name that you selected and click options at the bottom right.
9. COPY that name into the "Connect to database:" box under the "Connection Properties tab.
10. Click the Trust server certificate box so it shows a checkmark.
11. Click connect.
12. Now you can connect and use it :)

Microsoft SQL Server 2019 doesn't exist:
(thanks to TheOyinbooke's video).
1. Download Microsoft Access Database Engine 2016 Redistributable for free from their official site.
2. com/en-us/download/details.aspx?id=54920
3. Install
4. Now you can import Excel files without getting x64/x86 bit errors.

SQL ServerNative Client 11.0 doesn't exist:
1. Select "Microsoft OLE DB Provider for SQL Server" since Client 11.0 doesn't exist anymore.

Any other errors will be solved in the code that is uploaded.
