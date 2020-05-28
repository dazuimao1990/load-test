from locust import HttpLocust, TaskSet, task

# 定义用户行为
class MyTaskSet(TaskSet):

    @task
    def baidu_index(self):
        self.client.get("/api/todos")
    
    @task
    def baidu_index(self):
        self.client.get("/api/req")


class WebsiteUser(HttpLocust):
    task_set = MyTaskSet
    min_wait = 1000     # 单位为毫秒
    max_wait = 3000
