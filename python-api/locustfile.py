from locust import HttpUser, task, between

class FastAPITestUser(HttpUser):
    wait_time = between(0.1, 0.3)

    @task
    def get_cpu(self):
        self.client.get("/cpu")
