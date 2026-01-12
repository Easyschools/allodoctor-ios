//
//  ProfilePrivacyPolicyViewModel.swift
//  Allo-Doctor
//
//  Created for App Store Submission
//

import Foundation
import Combine

class ProfilePrivacyPolicyViewModel {
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
                ul {
                    margin-bottom: 15px;
                    padding-left: 20px;
                }
                .last-updated {
                    color: #666;
                    font-size: 14px;
                    font-style: italic;
                }
            </style>
        </head>
        <body>
            <h1>Privacy Policy</h1>
            <p class="last-updated">Last Updated: 07 January 2026</p>

            <h2>What Does This Privacy Policy Cover?</h2>
            <p>This Privacy Policy explains how Allo Doctor collects, uses, stores, and protects personal and medical information in connection with its medical and healthcare application, website, and related services (collectively referred to as the "Services").</p>
            <p>The Services may be used by healthcare providers such as hospitals, clinics, pharmacies, laboratories, diagnostic centers, and licensed medical professionals (collectively referred to as "Healthcare Organizations"), as well as by individual users such as patients or caregivers ("Individuals").</p>
            <p>A "User" refers to any individual who accesses or uses the Services. We may collect "User Data", which includes personal data and, where applicable, sensitive medical and health information, in order to provide the Services.</p>
            <p>Depending on the relationship, Allo Doctor may act as a data processor (when processing data on behalf of Healthcare Organizations) or as a data controller (when providing Services directly to Individuals).</p>

            <h2>Our Commitment</h2>
            <p>We are committed to protecting your privacy and safeguarding sensitive health information. We comply with applicable data protection laws:</p>
            <ul>
                <li>Protecting the confidentiality and security of personal and medical data</li>
                <li>Using data only for legitimate healthcare and service-related purposes</li>
                <li>Not selling personal or medical data to third parties</li>
                <li>Providing transparency and control over User Data</li>
                <li>Applying appropriate technical and organizational security measures</li>
            </ul>
            <p>All User Data is treated as strictly confidential.</p>

            <h2>Accounts Provided by Healthcare Organizations</h2>
            <p>If your access to the Services is provided by a Healthcare Organization, that organization acts as the data controller, and Allo Doctor acts as a data processor. The Healthcare Organization is responsible for ensuring a lawful basis and patient consent for processing medical data.</p>

            <h2>What User Data Do We Collect?</h2>
            <p><strong>Personal Information:</strong></p>
            <ul>
                <li>Full name</li>
                <li>Email address</li>
                <li>Phone number</li>
                <li>Country of residence</li>
                <li>Date of birth</li>
            </ul>

            <p><strong>Health and Medical Information (Sensitive Data):</strong></p>
            <ul>
                <li>Medical history and conditions</li>
                <li>Diagnoses and symptoms</li>
                <li>Prescriptions and medications</li>
                <li>Laboratory and diagnostic results</li>
                <li>Appointment and treatment details</li>
            </ul>

            <p><strong>Technical and Usage Data:</strong></p>
            <ul>
                <li>Log files and IP address</li>
                <li>Device and browser information</li>
                <li>App and website usage activity</li>
            </ul>

            <h2>How We Collect User Data</h2>
            <p>We collect data when:</p>
            <ul>
                <li>You register for or use the Services</li>
                <li>A Healthcare Organization provides data on your behalf</li>
                <li>You contact us for support or inquiries</li>
                <li>You interact with our website or mobile application</li>
            </ul>
            <p>We may use analytics tools to analyze usage trends. These tools do not access identifiable medical records.</p>

            <h2>Data Sharing</h2>
            <p>We do not sell User Data. We may share data only with:</p>
            <ul>
                <li>Authorized Healthcare Organizations</li>
                <li>Trusted service providers under strict agreements</li>
                <li>Legal or regulatory authorities when required by law</li>
            </ul>

            <h2>Legal Basis for Processing</h2>
            <p>We process User Data based on:</p>
            <ul>
                <li>Performance of a contract</li>
                <li>Legal obligations</li>
                <li>Legitimate interests related to healthcare delivery</li>
                <li>Explicit consent, especially for medical data</li>
            </ul>

            <h2>Marketing Communications</h2>
            <p>Users may receive service-related communications. Marketing messages can be opted out of at any time. Medical data is never used for marketing.</p>

            <h2>Data Security</h2>
            <p>We use encryption, access controls, and secure authentication methods to protect User Data. Users are responsible for keeping their login credentials secure.</p>

            <h2>Data Retention</h2>
            <p>User Data is retained only as long as necessary to provide Services or as required by healthcare and legal regulations.</p>

            <h2>International Data Transfers</h2>
            <p>Data may be processed outside your country of residence using appropriate safeguards, including Standard Contractual Clauses.</p>

            <h2>Children and Minors</h2>
            <p>Services involving minors require appropriate parental or guardian consent. Only necessary data is collected.</p>

            <h2>Your Rights</h2>
            <p>Users may have the right to access, correct, delete, restrict, or receive a copy of their data, subject to applicable laws.</p>

            <h2>Data Deletion</h2>
            <p>Users may request account and data deletion through the app or by contacting us. Certain medical records may be retained where legally required.</p>

            <h2>Changes to This Policy</h2>
            <p>We may update this Privacy Policy from time to time. The latest version will always be available within the Services.</p>

            <h2>Contact Us</h2>
            <p><strong>Allo Doctor</strong><br>
            Email: allodoctor@allodoctor<br>
            Phone: 201001971333</p>
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
                ul {
                    margin-bottom: 15px;
                    padding-right: 20px;
                }
                .last-updated {
                    color: #666;
                    font-size: 14px;
                    font-style: italic;
                }
            </style>
        </head>
        <body>
            <h1>سياسة الخصوصية</h1>
            <p class="last-updated">آخر تحديث: ٧ يناير ٢٠٢٦</p>

            <h2>ما الذي تغطيه سياسة الخصوصية هذه؟</h2>
            <p>توضح سياسة الخصوصية هذه كيفية قيام ألو دكتور بجمع واستخدام وتخزين وحماية البيانات الشخصية والطبية المتعلقة باستخدام تطبيق وخدمات الرعاية الصحية الخاصة بنا (ويشار إليها مجتمعة بـ "الخدمات").</p>
            <p>قد يتم استخدام الخدمات من قبل مقدمي الرعاية الصحية مثل المستشفيات والعيادات والصيدليات والمعامل ومراكز الأشعة والأطباء المرخصين (ويشار إليهم بـ "الجهات الطبية") أو من قبل الأفراد مثل المرضى أو مقدمي الرعاية.</p>
            <p>يشير مصطلح "المستخدم" إلى أي شخص يستخدم الخدمات. وقد نقوم بجمع "بيانات المستخدم" التي تشمل البيانات الشخصية والبيانات الطبية الحساسة عند الاقتضاء.</p>
            <p>بحسب طبيعة الاستخدام، قد تعمل ألو دكتور بصفتها معالج بيانات أو متحكم بيانات وفقًا للقوانين المعمول بها.</p>

            <h2>التزامنا</h2>
            <p>نلتزم بحماية خصوصيتك والحفاظ على سرية البيانات الطبية، ونتقيد بقوانين حماية البيانات المعمول بها، ونتبع المبادئ التالية:</p>
            <ul>
                <li>حماية سرية وأمن البيانات الشخصية والطبية</li>
                <li>استخدام البيانات فقط لأغراض تقديم الرعاية الصحية والخدمات</li>
                <li>عدم بيع البيانات الشخصية أو الطبية لأي طرف ثالث</li>
                <li>تمكين المستخدمين من التحكم في بياناتهم</li>
                <li>تطبيق تدابير أمنية تقنية وتنظيمية مناسبة</li>
            </ul>

            <h2>الحسابات المقدمة من الجهات الطبية</h2>
            <p>إذا تم تزويدك بالخدمات من خلال جهة طبية، فإن تلك الجهة تُعد متحكم البيانات، بينما تعمل ألو دكتور كـ معالج بيانات وفقًا لتعليماتها.</p>

            <h2>ما البيانات التي نقوم بجمعها؟</h2>
            <p><strong>البيانات الشخصية:</strong></p>
            <ul>
                <li>الاسم الكامل</li>
                <li>البريد الإلكتروني</li>
                <li>رقم الهاتف</li>
                <li>دولة الإقامة</li>
                <li>تاريخ الميلاد</li>
            </ul>

            <p><strong>البيانات الطبية (بيانات حساسة):</strong></p>
            <ul>
                <li>التاريخ المرضي</li>
                <li>التشخيصات والأعراض</li>
                <li>الأدوية والوصفات الطبية</li>
                <li>نتائج التحاليل والفحوصات</li>
                <li>تفاصيل المواعيد والعلاج</li>
            </ul>

            <p><strong>بيانات الاستخدام والتقنية:</strong></p>
            <ul>
                <li>عنوان IP وملفات السجل</li>
                <li>نوع الجهاز والمتصفح</li>
                <li>نشاط الاستخدام داخل التطبيق أو الموقع</li>
            </ul>

            <h2>كيفية جمع البيانات</h2>
            <p>نقوم بجمع البيانات عندما:</p>
            <ul>
                <li>تقوم بالتسجيل أو استخدام الخدمات</li>
                <li>تقوم جهة طبية بإدخال بيانات نيابةً عنك</li>
                <li>تتواصل معنا للاستفسار أو الدعم</li>
                <li>تتفاعل مع الموقع أو التطبيق</li>
            </ul>
            <p>قد نستخدم أدوات تحليل لتحسين الخدمات دون الوصول إلى السجلات الطبية الشخصية.</p>

            <h2>مشاركة البيانات</h2>
            <p>نحن لا نبيع بيانات المستخدم. وقد نشارك البيانات فقط مع:</p>
            <ul>
                <li>الجهات الطبية المخولة</li>
                <li>مزودي الخدمات التقنية بموجب اتفاقيات صارمة</li>
                <li>الجهات القانونية عند الالتزام بالقانون</li>
            </ul>

            <h2>الأساس القانوني لمعالجة البيانات</h2>
            <p>نقوم بمعالجة البيانات بناءً على:</p>
            <ul>
                <li>تنفيذ عقد</li>
                <li>الالتزام القانوني</li>
                <li>المصالح المشروعة المتعلقة بتقديم الرعاية الصحية</li>
                <li>موافقة المستخدم الصريحة، خاصة للبيانات الطبية</li>
            </ul>

            <h2>الرسائل التسويقية</h2>
            <p>قد نرسل رسائل خدمية أو تعريفية. يمكن إلغاء الاشتراك في أي وقت. لا تُستخدم البيانات الطبية لأغراض تسويقية.</p>

            <h2>أمن البيانات</h2>
            <p>نطبق إجراءات أمنية قوية مثل التشفير وضوابط الوصول. ويتحمل المستخدم مسؤولية حماية بيانات تسجيل الدخول الخاصة به.</p>

            <h2>الاحتفاظ بالبيانات</h2>
            <p>نحتفظ بالبيانات فقط للمدة اللازمة لتقديم الخدمات أو وفقًا للمتطلبات القانونية والطبية.</p>

            <h2>نقل البيانات خارج الدولة</h2>
            <p>قد يتم نقل البيانات ومعالجتها خارج بلد الإقامة مع توفير الضمانات القانونية اللازمة.</p>

            <h2>الأطفال والقُصّر</h2>
            <p>تتطلب الخدمات المقدمة للقُصّر موافقة ولي الأمر أو الجهة الطبية المختصة، ويتم جمع الحد الأدنى من البيانات فقط.</p>

            <h2>حقوق المستخدم</h2>
            <p>يحق للمستخدم طلب الوصول إلى بياناته أو تعديلها أو حذفها أو تقييد معالجتها أو الحصول على نسخة منها، وفقًا للقانون.</p>

            <h2>حذف البيانات</h2>
            <p>يمكن للمستخدم طلب حذف الحساب والبيانات. وقد يتم الاحتفاظ ببعض السجلات الطبية إذا تطلب القانون ذلك.</p>

            <h2>التعديلات على سياسة الخصوصية</h2>
            <p>قد نقوم بتحديث هذه السياسة من وقت لآخر، وسيتم توضيح تاريخ آخر تحديث دائمًا.</p>

            <h2>التواصل معنا</h2>
            <p><strong>ألو دكتور</strong><br>
            البريد الإلكتروني: allodoctor@allodoctor<br>
            رقم الهاتف: 201001971333</p>
        </body>
        </html>
        """
    }
}
