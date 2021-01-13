from locust import HttpUser, task, between

class QuickstartUser(HttpUser):
    @task
    def hello_world(self):
        self.client.get("/mysql.html")
    wait_time = between(0.5, 10)
