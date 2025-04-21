// vite.config.mts
import { defineConfig } from "file:///Users/mj/dev/stock/stock_monitor/node_modules/vite/dist/node/index.js";
import ViteRails from "file:///Users/mj/dev/stock/stock_monitor/node_modules/vite-plugin-rails/dist/index.js";
import tailwindcss from "file:///Users/mj/dev/stock/stock_monitor/node_modules/@tailwindcss/vite/dist/index.mjs";
var vite_config_default = defineConfig({
  plugins: [
    tailwindcss(),
    ViteRails({
      envVars: { RAILS_ENV: "development" },
      envOptions: { defineOn: "import.meta.env" },
      fullReload: {
        additionalPaths: ["config/routes.rb", "app/views/**/*"],
        delay: 300
      }
    })
  ],
  build: { sourcemap: false }
});
export {
  vite_config_default as default
};
//# sourceMappingURL=data:application/json;base64,ewogICJ2ZXJzaW9uIjogMywKICAic291cmNlcyI6IFsidml0ZS5jb25maWcubXRzIl0sCiAgInNvdXJjZXNDb250ZW50IjogWyJjb25zdCBfX3ZpdGVfaW5qZWN0ZWRfb3JpZ2luYWxfZGlybmFtZSA9IFwiL1VzZXJzL21qL2Rldi9zdG9jay9zdG9ja19tb25pdG9yXCI7Y29uc3QgX192aXRlX2luamVjdGVkX29yaWdpbmFsX2ZpbGVuYW1lID0gXCIvVXNlcnMvbWovZGV2L3N0b2NrL3N0b2NrX21vbml0b3Ivdml0ZS5jb25maWcubXRzXCI7Y29uc3QgX192aXRlX2luamVjdGVkX29yaWdpbmFsX2ltcG9ydF9tZXRhX3VybCA9IFwiZmlsZTovLy9Vc2Vycy9tai9kZXYvc3RvY2svc3RvY2tfbW9uaXRvci92aXRlLmNvbmZpZy5tdHNcIjtpbXBvcnQgeyBkZWZpbmVDb25maWcgfSBmcm9tICd2aXRlJ1xuaW1wb3J0IFZpdGVSYWlscyBmcm9tIFwidml0ZS1wbHVnaW4tcmFpbHNcIlxuLy8gQHRzLWlnbm9yZVxuaW1wb3J0IHRhaWx3aW5kY3NzIGZyb20gXCJAdGFpbHdpbmRjc3Mvdml0ZVwiXG5cbmV4cG9ydCBkZWZhdWx0IGRlZmluZUNvbmZpZyh7XG4gIHBsdWdpbnM6IFtcbiAgICB0YWlsd2luZGNzcygpLFxuICAgIFZpdGVSYWlscyh7XG4gICAgICBlbnZWYXJzOiB7IFJBSUxTX0VOVjogXCJkZXZlbG9wbWVudFwiIH0sXG4gICAgICBlbnZPcHRpb25zOiB7IGRlZmluZU9uOiBcImltcG9ydC5tZXRhLmVudlwiIH0sXG4gICAgICBmdWxsUmVsb2FkOiB7XG4gICAgICAgIGFkZGl0aW9uYWxQYXRoczogW1wiY29uZmlnL3JvdXRlcy5yYlwiLCBcImFwcC92aWV3cy8qKi8qXCJdLFxuICAgICAgICBkZWxheTogMzAwLFxuICAgICAgfSxcbiAgICB9KSxcbiAgXSxcbiAgYnVpbGQ6IHsgc291cmNlbWFwOiBmYWxzZSB9LFxufSkiXSwKICAibWFwcGluZ3MiOiAiO0FBQXVSLFNBQVMsb0JBQW9CO0FBQ3BULE9BQU8sZUFBZTtBQUV0QixPQUFPLGlCQUFpQjtBQUV4QixJQUFPLHNCQUFRLGFBQWE7QUFBQSxFQUMxQixTQUFTO0FBQUEsSUFDUCxZQUFZO0FBQUEsSUFDWixVQUFVO0FBQUEsTUFDUixTQUFTLEVBQUUsV0FBVyxjQUFjO0FBQUEsTUFDcEMsWUFBWSxFQUFFLFVBQVUsa0JBQWtCO0FBQUEsTUFDMUMsWUFBWTtBQUFBLFFBQ1YsaUJBQWlCLENBQUMsb0JBQW9CLGdCQUFnQjtBQUFBLFFBQ3RELE9BQU87QUFBQSxNQUNUO0FBQUEsSUFDRixDQUFDO0FBQUEsRUFDSDtBQUFBLEVBQ0EsT0FBTyxFQUFFLFdBQVcsTUFBTTtBQUM1QixDQUFDOyIsCiAgIm5hbWVzIjogW10KfQo=
