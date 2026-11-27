# Saigon Connection Center

Web app quản lý học sinh, học phí và đối chiếu giao dịch. Đăng nhập dùng Supabase Auth; dữ liệu ứng dụng được đồng bộ trong bảng `public.center_data` và giới hạn bằng Row Level Security.

## Cấu hình Supabase

1. Tạo project Supabase ở tổ chức đã chọn và chạy migration `supabase/migrations/202611270001_center_data.sql`.
2. Tắt public sign-up trong Authentication settings. Tạo/invite riêng hai người dùng.
3. Trong Supabase Auth, đặt `app_metadata.role` thành `owner` cho chủ trung tâm và `accountant` cho kế toán. Role phải nằm trong app metadata do máy chủ quản lý, không dùng user metadata.
4. Sao chép Project URL và publishable (anon) key vào `SUPABASE_URL` và `SUPABASE_ANON_KEY` trong môi trường chạy app. Không dùng service-role key ở trình duyệt.

Bảng dữ liệu được tạo chưa có hàng nào. Hàng dữ liệu trống đầu tiên chỉ được tạo khi người dùng được cấp quyền lưu thay đổi; không có học sinh mẫu.

## Chạy cục bộ

Yêu cầu Node.js 20+. Đặt hai biến môi trường ở trên rồi chạy `npm start`; mở `http://localhost:3000`.

## Render

Blueprint `render.yaml` tạo web service ở Singapore. Kết nối repo GitHub/GitLab có các file này, tạo Blueprint trong Render và đặt `SUPABASE_URL` cùng `SUPABASE_ANON_KEY` ở Environment. Không thêm mật khẩu hoặc service-role key vào repo.

