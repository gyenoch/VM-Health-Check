# ��� VM Health Check Script

A simple Bash script that checks the **health of a virtual machine** based on:
- CPU usage
- Memory usage
- Disk usage
- Load average

---

## ��� Usage

1. Clone this repository:
   ```bash
   git clone https://github.com/gyenoch/VM-Health-Check.git

   cd VM-Health-Check
   ```

2. Make the file executable:
   ```bash
   chmod +x health_check.sh
   ```

3. Run a quick Health Check:
   ```bash
   ./health_check.sh
   ```

4. Run with the explain argument for a detailed summary:
   ```bash
   ./health_check.sh explain
   ```