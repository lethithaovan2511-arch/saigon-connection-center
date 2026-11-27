# Saigon Connection Center

Web app quản lý học sinh, học phí và đối chiếu giao dịch. Đăng nhập dùng Supabase Auth; dữ liệu ứng dụng được đồng bộ trong bảng `public.center_data` và giới hạn bằng Row Level Security.

## Cấu hình Supabase

1. Chạy migration `supabase/migrations/202611270001_center_data.sql` và `supabase/migrations/202611270002_auth_signup_allowlist.sql`.
2. Thêm email được phép đăng ký vào schema riêng `private.auth_signup_allowlist` với role `owner` hoặc `accountant`. Schema và bảng này không được cấp quyền cho người dùng thường. Email chủ trung tâm được lưu ở đây trong Supabase, không nằm trong repo.
3. Trong Authentication → URL Configuration, đặt Site URL và Redirect URL là URL Render của app. Người dùng nhập email cùng mật khẩu họ tự chọn ở nút “Tạo tài khoản”; họ cần xác nhận email trước khi đăng nhập.
4. Sao chép Project URL và publishable (anon) key vào `SUPABASE_URL` và `SUPABASE_ANON_KEY` trong môi trường chạy app. Không dùng service-role key ở trình duyệt.

Bảng dữ liệu được tạo chưa có hàng nào. Hàng dữ liệu trống đầu tiên chỉ được tạo khi người dùng được cấp quyền lưu thay đổi; không có học sinh mẫu. Trigger Auth từ chối đăng ký ngoài danh sách cho phép và tự gán role trong app metadata.

## Chạy cục bộ

Yêu cầu Node.js 20+. Đặt hai biến môi trường ở trên rồi chạy `npm start`; mở `http://localhost:3000`.

## Render

Blueprint `render.yaml` tạo web service ở Singapore. Kết nối repo GitHub/GitLab có các file này, tạo Blueprint trong Render và đặt `SUPABASE_URL` cùng `SUPABASE_ANON_KEY` ở Environment. Không thêm mật khẩu hoặc service-role key vào repo.

