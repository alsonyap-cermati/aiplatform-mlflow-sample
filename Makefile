# Feel free to edit and set to your own variables here
GCP_PROJECT=<GCP_PROJECT>

.PHONY: build tag push

build:
	docker build -t training .

tag:
	docker tag training gcr.io/$(GCP_PROJECT)/training:latest

push:
	docker push gcr.io/$(GCP_PROJECT)/training:latest

submit:
	@if [ "$(GPU)" = True ]; then \
		gcloud --project=$(GCP_PROJECT) ai-platform jobs submit training \
		"$(MODEL)_training_`date +'%Y%m%d_%H%M%S'`" \
		--master-image-uri gcr.io/$(GCP_PROJECT)/training:latest \
		--region asia-southeast1 \
		--scale-tier custom \
		--master-machine-type n1-standard-4 \
		--master-accelerator count=1,type=nvidia-tesla-t4 \
		-- \
		$(MODEL); \
	else \
		gcloud --project=$(GCP_PROJECT) ai-platform jobs submit training \
		"$(MODEL)_training_`date +'%Y%m%d_%H%M%S'`" \
		--master-image-uri gcr.io/$(GCP_PROJECT)/training:latest \
		--region asia-southeast1 \
		--scale-tier basic \
		-- \
		$(MODEL); \
	fi