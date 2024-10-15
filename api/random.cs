using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using System.Net.Http;

namespace api;

public static class Random
{
    [FunctionName("random")]
    public static async Task<IActionResult> Run(
        [HttpTrigger(AuthorizationLevel.Anonymous, "get", "post", Route = null)] HttpRequest req,
        ILogger log)
    {
        log.LogInformation("C# HTTP trigger function processed a request.");

        var httpClient = new HttpClient(); // Risk of running out of sockets?
        var response = await httpClient.GetAsync("https://zenquotes.io/api/random");
        var responseMessage = await response.Content.ReadAsStringAsync();

        log.LogInformation($"Forwarding {responseMessage}");

        return new OkObjectResult(responseMessage);
    }
}
