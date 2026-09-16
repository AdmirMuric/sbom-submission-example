using Humanizer;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Newtonsoft.Json;
using Serilog;

using IHost host = Host.CreateDefaultBuilder(args)
    .UseSerilog((_, configuration) => configuration.WriteTo.Console())
    .ConfigureServices(services =>
    {
        services.AddHostedService<HelloWorldService>();
    })
    .Build();

await host.RunAsync();

internal sealed class HelloWorldService : IHostedService
{
    private readonly IHostApplicationLifetime _applicationLifetime;

    public HelloWorldService(IHostApplicationLifetime applicationLifetime)
    {
        _applicationLifetime = applicationLifetime;
    }

    public Task StartAsync(CancellationToken cancellationToken)
    {
        var message = new
        {
            Text = "Hello from an SBOM dependency submission sample!!",
            Started = DateTimeOffset.UtcNow.Humanize()
        };

        Console.WriteLine(JsonConvert.SerializeObject(message, Formatting.Indented));
        _applicationLifetime.StopApplication();

        return Task.CompletedTask;
    }

    public Task StopAsync(CancellationToken cancellationToken) => Task.CompletedTask;
}
