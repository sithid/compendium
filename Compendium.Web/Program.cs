using Compendium.Web.Components;

namespace Compendium.Web {
    public class Program {
        public static void Main(string[] args) {
            WebApplicationBuilder builder = WebApplication.CreateBuilder(args);

            // Add services to the container.
            builder.Services.AddRazorComponents();

            builder.Services.AddCors(options => {
                options.AddPolicy("BlazorClientPolicy", policy => {
                    policy.WithOrigins("https://localhost:7008")
                           .AllowAnyMethod()
                           .AllowAnyHeader();
                });
            });

            WebApplication app = builder.Build();

            // Configure the HTTP request pipeline.
            if (!app.Environment.IsDevelopment()) {
                app.UseExceptionHandler("/Error");
                // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
                app.UseHsts();
            }

            app.UseHttpsRedirection();

            app.UseAntiforgery();

            app.MapStaticAssets();
            app.MapRazorComponents<App>();

            app.Run();
        }
    }
}
