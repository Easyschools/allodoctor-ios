//
//  ProfileRefundPolicyViewModel.swift
//  Allo-Doctor
//
//  Created for App Store Submission
//

import Foundation
import Combine

class ProfileRefundPolicyViewModel {
    var coordinator: HomeCoordinatorContact?
    private var cancellables = Set<AnyCancellable>()

    // Initializer
    init(coordinator: HomeCoordinatorContact? = nil) {
        self.coordinator = coordinator
    }

    func navBack() {
        coordinator?.navigateBack()
    }

    func getEnglishPolicyHTML() -> String {
        return """
        <!DOCTYPE html>
        <html>
        <head>
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <style>
                body {
                    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
                    padding: 20px;
                    line-height: 1.6;
                    color: #333;
                }
                h1 {
                    color: #2C5F8D;
                    font-size: 24px;
                    margin-bottom: 10px;
                }
                h2 {
                    color: #2C5F8D;
                    font-size: 18px;
                    margin-top: 20px;
                    margin-bottom: 10px;
                }
                p {
                    margin-bottom: 15px;
                }
                .last-updated {
                    color: #666;
                    font-size: 14px;
                    font-style: italic;
                }
            </style>
        </head>
        <body>
            <h1>Refund Policy</h1>
            <p class="last-updated">Last Updated: 07 January 2026</p>

            <h2>Scope of the Refund Policy</h2>
            <p>This Refund Policy outlines the terms and conditions governing refund requests for medical services booked or purchased through the medical application.</p>

            <h2>Third-Party Service Providers</h2>
            <p>The application operates as a platform connecting users with independent medical service providers, including but not limited to doctors, clinics, hospitals, laboratories, pharmacies, or other medical entities.</p>

            <h2>Refunds Based on Service Provider Policy</h2>
            <p>All refund requests are subject to the refund policy of the specific service provider from whom the service was obtained. Refund policies may vary between providers, and the application has no control over their refund terms or decisions.</p>

            <h2>Application Responsibility</h2>
            <p>The application's role is limited to facilitating bookings or payments and bears no legal or financial responsibility for refund approvals or rejections made by service providers.</p>

            <h2>Non-Refundable Services</h2>
            <p>Certain medical services may be non-refundable by nature, including completed medical consultations, emergency services, or services that have been partially or fully delivered, in accordance with the service provider's policy.</p>

            <h2>Refund Request Process</h2>
            <p>Users must contact the relevant service provider directly to request a refund in accordance with their terms and conditions. The application may offer technical or guidance support when needed but does not guarantee any refund outcome.</p>

            <h2>Changes to This Refund Policy</h2>
            <p>The application reserves the right to amend this Refund Policy at any time. Any updates will be communicated through the application or official channels.</p>
        </body>
        </html>
        """
    }

    func getArabicPolicyHTML() -> String {
        return """
        <!DOCTYPE html>
        <html dir="rtl">
        <head>
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <style>
                body {
                    font-family: -apple-system, BlinkMacSystemFont, 'Cairo', 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
                    padding: 20px;
                    line-height: 1.8;
                    color: #333;
                    direction: rtl;
                    text-align: right;
                }
                h1 {
                    color: #2C5F8D;
                    font-size: 24px;
                    margin-bottom: 10px;
                }
                h2 {
                    color: #2C5F8D;
                    font-size: 18px;
                    margin-top: 20px;
                    margin-bottom: 10px;
                }
                p {
                    margin-bottom: 15px;
                }
                .last-updated {
                    color: #666;
                    font-size: 14px;
                    font-style: italic;
                }
            </style>
        </head>
        <body>
            <h1>سياسة الاسترداد</h1>
            <p class="last-updated">آخر تحديث: ٧ يناير ٢٠٢٦</p>

            <h2>نطاق سياسة الاسترداد</h2>
            <p>توضح سياسة الاسترداد هذه الشروط والأحكام المتعلقة بطلبات استرداد المبالغ للخدمات الطبية التي يتم حجزها أو شراؤها من خلال التطبيق الطبي.</p>

            <h2>مقدمو الخدمات الخارجيون</h2>
            <p>يعمل التطبيق كمنصة تربط المستخدمين بمقدمي خدمات طبية مستقلين، بما في ذلك على سبيل المثال لا الحصر: الأطباء، العيادات، المستشفيات، المختبرات، الصيدليات، أو أي جهات طبية أخرى.</p>

            <h2>سياسة الاسترداد حسب مقدم الخدمة</h2>
            <p>تخضع جميع طلبات الاسترداد لسياسة الاسترداد الخاصة بمقدم الخدمة الذي تم الحصول على الخدمة من خلاله. تختلف سياسات الاسترداد من مقدم خدمة إلى آخر، ولا يتحكم التطبيق في شروط أو قرارات الاسترداد الخاصة بهم.</p>

            <h2>مسؤولية التطبيق</h2>
            <p>يقتصر دور التطبيق على تسهيل عملية الحجز أو الدفع ولا يتحمل أي مسؤولية قانونية أو مالية عن قرارات قبول أو رفض الاسترداد التي يتخذها مقدمو الخدمات.</p>

            <h2>الخدمات غير القابلة للاسترداد</h2>
            <p>قد تكون بعض الخدمات الطبية غير قابلة للاسترداد بطبيعتها، مثل الاستشارات الطبية المكتملة، الخدمات الطارئة، أو الخدمات التي تم تقديمها جزئيًا أو كليًا، وذلك وفقًا لسياسة مقدم الخدمة.</p>

            <h2>آلية طلب الاسترداد</h2>
            <p>يجب على المستخدم التواصل مباشرة مع مقدم الخدمة المعني لطلب الاسترداد وفقًا لسياساته وشروطه. ويمكن للتطبيق تقديم دعم فني أو إرشادي عند الحاجة دون ضمان قبول طلب الاسترداد.</p>

            <h2>التعديلات على سياسة الاسترداد</h2>
            <p>يحتفظ التطبيق بالحق في تعديل سياسة الاسترداد هذه في أي وقت، وسيتم نشر أي تحديثات داخل التطبيق أو عبر القنوات الرسمية.</p>
        </body>
        </html>
        """
    }
}
