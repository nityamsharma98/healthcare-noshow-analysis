# Patient No-Show project — data pipeline
# Update the data, run `make build`, commit & push -> the live dashboard updates.

.PHONY: build data dashboard serve clean help

help:
	@echo "make build      - full pipeline: clean raw data + rebuild dashboard data"
	@echo "make data       - clean data/raw -> data/processed"
	@echo "make dashboard  - rebuild dashboard_data.js/.json from processed data"
	@echo "make serve      - preview the dashboard locally at http://localhost:8000"
	@echo "make clean       - remove generated files"

data:
	python3 scripts/01_clean_profile.py

dashboard: data
	python3 scripts/02_build_dashboard_data.py

build: dashboard
	@echo "Pipeline complete. Commit and push to update the live dashboard."

serve:
	@echo "Open http://localhost:8000/dashboard/noshow_dashboard.html"
	python3 -m http.server 8000

clean:
	rm -f data/processed/appointments_clean.csv dashboard/dashboard_data.js dashboard/dashboard_data.json
