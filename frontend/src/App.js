import {
    BrowserRouter,
    Routes,
    Route,
    Navigate,
    Link
} from "react-router-dom";

import LoginPage from "./pages/LoginPage";
import RegisterPage from "./pages/RegisterPage";
import FacilitiesPage from "./pages/FacilitiesPage";
import ProfilePage from "./pages/ProfilePage";

import ProtectedRoute from "./auth/ProtectedRoute";
import { AuthProvider, useAuth } from "./auth/AuthContext";

import AppLayout from "./components/AppLayout";

import "./styles/app.css";
import CustomerAddressPage from "./pages/CustomerAddressPage";
import ShipmentRequestsPage from "./pages/ShipmentRequestsPage";
import ShipmentsPage from "./pages/ShipmentsPage";
import PackageScansPage from "./pages/PackageScansPage";
import TrackingEventsPage from "./pages/TrackingEventsPage";
import TransportOrdersPage from "./pages/TransportOrdersPage";
import DeliveryAttemptsPage from "./pages/DeliveryAttemptsPage";
import ProofOfDeliveriesPage from "./pages/ProofOfDeliveriesPage";
import MyShipmentRequestsPage from "./pages/MyShipmentRequestsPage";
import DeliveryAssignmentsPage from "./pages/DeliveryAssignmentsPage";

function Dashboard() {
    const { user } = useAuth();
    const displayName = user?.username || "User";

    const services = [
        { icon: "🚚", title: "Express Delivery", description: "Same-day and next-day delivery across major cities", color: "#e3f2fd" },
        { icon: "📦", title: "Standard Shipping", description: "Reliable 2-3 day delivery for your packages", color: "#f3e5f5" },
        { icon: "🏪", title: "Warehousing", description: "Secure storage and distribution centers", color: "#e8f5e9" },
        { icon: "🔍", title: "Real-time Tracking", description: "Track your shipments at every step", color: "#fff3e0" },
        { icon: "🛡️", title: "Insurance", description: "Protect your valuable shipments", color: "#ffebee" },
        { icon: "🌏", title: "Nationwide Network", description: "Coverage across 28 states and 500+ cities", color: "#f1f8e9" },
    ];

    const stats = [
        { value: "10M+", label: "Packages Delivered", icon: "📦" },
        { value: "500+", label: "Cities Covered", icon: "🏙️" },
        { value: "24/7", label: "Customer Support", icon: "🕐" },
        { value: "99.9%", label: "On-time Delivery", icon: "⚡" },
    ];

    const workflowSteps = [
        { step: 1, title: "Request Pickup", description: "Schedule a pickup or drop off", icon: "📞", path: "/my/shipment-requests" },
        { step: 2, title: "Package Processing", description: "Sort and scan at facility", icon: "🔍", path: "/package-scans" },
        { step: 3, title: "Dispatch", description: "Assign vehicle and route", icon: "🚛", path: "/transport-orders" },
        { step: 4, title: "Delivery", description: "Deliver to your doorstep", icon: "🏠", path: "/delivery-attempts" },
    ];

    const testimonials = [
        { name: "Rajesh Kumar", company: "Tech Solutions Ltd", quote: "ELMS has transformed our logistics. Fast, reliable, and always on time!", rating: 5 },
        { name: "Priya Sharma", company: "Fashion Retail Co", quote: "The real-time tracking is amazing. Our customers love knowing where their packages are.", rating: 5 },
        { name: "Amit Patel", company: "Pharma Distributors", quote: "Professional service with secure handling for our sensitive shipments.", rating: 4 },
    ];

    return (
        <div style={styles.container}>
            {/* Hero Section */}
            <div style={styles.hero}>
                <div style={styles.heroContent}>
                    <h1 style={styles.heroTitle}>ELMS Logistics</h1>
                    <p style={styles.heroTagline}>Delivering Excellence Across India</p>
                    <p style={styles.heroDescription}>
                        Your trusted partner for all logistics needs. From small parcels to large freight,
                        we ensure your packages reach their destination safely and on time.
                    </p>
                    <div style={styles.heroButtons}>
                        <Link to="/my/shipment-requests" style={styles.primaryButton}>
                            Track Shipment
                        </Link>
                        <Link to="/register" style={styles.secondaryButton}>
                            Get Started
                        </Link>
                    </div>
                    {user && (
                        <p style={styles.welcomeText}>
                            Welcome back, <strong>{displayName}</strong>!
                        </p>
                    )}
                </div>
            </div>

            {/* Stats Section */}
            <div style={styles.statsSection}>
                {stats.map(stat => (
                    <div key={stat.label} style={styles.statCard}>
                        <div style={styles.statIcon}>{stat.icon}</div>
                        <div style={styles.statValue}>{stat.value}</div>
                        <div style={styles.statLabel}>{stat.label}</div>
                    </div>
                ))}
            </div>

            {/* About Section */}
            <div style={styles.aboutSection}>
                <div style={styles.aboutContent}>
                    <h2 style={styles.sectionTitle}>About ELMS</h2>
                    <p style={styles.aboutText}>
                        Founded in 2024, ELMS (Enterprise Logistics Management System) has quickly become
                        one of India's leading courier and logistics companies. With a network spanning
                        over 500 cities and a fleet of modern vehicles, we provide end-to-end logistics
                        solutions for businesses and individuals alike.
                    </p>
                    <p style={styles.aboutText}>
                        Our state-of-the-art tracking system ensures complete transparency throughout
                        the delivery process. From the moment your package is picked up to the instant
                        it's delivered, you can monitor its journey in real-time.
                    </p>
                    <div style={styles.featuresList}>
                        <div style={styles.featureItem}>✓ Real-time GPS Tracking</div>
                        <div style={styles.featureItem}>✓ Secure Warehousing</div>
                        <div style={styles.featureItem}>✓ Express & Standard Delivery</div>
                        <div style={styles.featureItem}>✓ Insurance Coverage</div>
                        <div style={styles.featureItem}>✓ 24/7 Customer Support</div>
                        <div style={styles.featureItem}>✓ Nationwide Coverage</div>
                    </div>
                </div>
            </div>

            {/* Services Section */}
            <div style={styles.servicesSection}>
                <h2 style={styles.sectionTitle}>Our Services</h2>
                <div style={styles.servicesGrid}>
                    {services.map(service => (
                        <div key={service.title} style={{ ...styles.serviceCard, background: service.color }}>
                            <div style={styles.serviceIcon}>{service.icon}</div>
                            <h3 style={styles.serviceTitle}>{service.title}</h3>
                            <p style={styles.serviceDesc}>{service.description}</p>
                        </div>
                    ))}
                </div>
            </div>

            {/* How It Works */}
            <div style={styles.howItWorksSection}>
                <h2 style={styles.sectionTitle}>How It Works</h2>
                <div style={styles.workflowGrid}>
                    {workflowSteps.map((step, index) => (
                        <div key={step.step} style={styles.workflowCard}>
                            <Link to={step.path} style={styles.workflowLink}>
                                <div style={styles.workflowIcon}>{step.icon}</div>
                                <div style={styles.workflowStep}>Step {step.step}</div>
                                <div style={styles.workflowTitle}>{step.title}</div>
                                <div style={styles.workflowDesc}>{step.description}</div>
                            </Link>
                            {index < workflowSteps.length - 1 && (
                                <div style={styles.workflowArrow}>→</div>
                            )}
                        </div>
                    ))}
                </div>
            </div>

            {/* Testimonials */}
            <div style={styles.testimonialsSection}>
                <h2 style={styles.sectionTitle}>What Our Customers Say</h2>
                <div style={styles.testimonialsGrid}>
                    {testimonials.map(testimonial => (
                        <div key={testimonial.name} style={styles.testimonialCard}>
                            <div style={styles.testimonialStars}>
                                {'★'.repeat(testimonial.rating)}{'☆'.repeat(5 - testimonial.rating)}
                            </div>
                            <p style={styles.testimonialQuote}>"{testimonial.quote}"</p>
                            <div style={styles.testimonialAuthor}>
                                <div style={styles.testimonialAvatar}>
                                    {testimonial.name.charAt(0)}
                                </div>
                                <div>
                                    <div style={styles.testimonialName}>{testimonial.name}</div>
                                    <div style={styles.testimonialCompany}>{testimonial.company}</div>
                                </div>
                            </div>
                        </div>
                    ))}
                </div>
            </div>

            {/* CTA Section */}
            <div style={styles.ctaSection}>
                <h2 style={styles.ctaTitle}>Ready to Ship with ELMS?</h2>
                <p style={styles.ctaText}>Join thousands of satisfied customers today</p>
                <Link to="/register" style={styles.ctaButton}>
                    Create Free Account
                </Link>
            </div>

            {/* Footer */}
            <div style={styles.footer}>
                <p style={styles.footerText}>
                    © 2024 ELMS Logistics. All rights reserved. | Terms of Service | Privacy Policy
                </p>
            </div>
        </div>
    );
}

const styles = {
    container: {
        minHeight: "100vh",
        backgroundColor: "#fafafa",
        fontFamily: "'Segoe UI', Tahoma, Geneva, Verdana, sans-serif",
    },
    hero: {
        background: "linear-gradient(135deg, #1a237e 0%, #283593 50%, #3949ab 100%)",
        color: "white",
        padding: "60px 30px",
        textAlign: "center",
    },
    heroContent: {
        maxWidth: "800px",
        margin: "0 auto",
    },
    heroTitle: {
        fontSize: "48px",
        fontWeight: "700",
        margin: "0 0 10px",
        letterSpacing: "2px",
    },
    heroTagline: {
        fontSize: "20px",
        margin: "0 0 20px",
        opacity: "0.9",
    },
    heroDescription: {
        fontSize: "16px",
        lineHeight: "1.6",
        margin: "0 0 30px",
        opacity: "0.8",
        maxWidth: "600px",
        margin: "0 auto 30px",
    },
    heroButtons: {
        display: "flex",
        gap: "15px",
        justifyContent: "center",
        marginBottom: "20px",
    },
    primaryButton: {
        padding: "12px 30px",
        background: "#ff6f00",
        color: "white",
        border: "none",
        borderRadius: "25px",
        fontSize: "16px",
        fontWeight: "600",
        textDecoration: "none",
        transition: "transform 0.2s, box-shadow 0.2s",
        "&:hover": {
            transform: "translateY(-2px)",
            boxShadow: "0 4px 15px rgba(255,111,0,0.3)",
        },
    },
    secondaryButton: {
        padding: "12px 30px",
        background: "transparent",
        color: "white",
        border: "2px solid white",
        borderRadius: "25px",
        fontSize: "16px",
        fontWeight: "600",
        textDecoration: "none",
        transition: "background 0.2s",
        "&:hover": {
            background: "rgba(255,255,255,0.1)",
        },
    },
    welcomeText: {
        fontSize: "14px",
        opacity: "0.8",
    },
    statsSection: {
        display: "grid",
        gridTemplateColumns: "repeat(auto-fit, minmax(200px, 1fr))",
        gap: "20px",
        padding: "30px",
        maxWidth: "1200px",
        margin: "-50px auto 0",
        position: "relative",
        zIndex: 1,
    },
    statCard: {
        background: "white",
        padding: "25px",
        borderRadius: "12px",
        textAlign: "center",
        boxShadow: "0 4px 15px rgba(0,0,0,0.1)",
        transition: "transform 0.2s",
        "&:hover": {
            transform: "translateY(-5px)",
        },
    },
    statIcon: {
        fontSize: "30px",
        marginBottom: "10px",
    },
    statValue: {
        fontSize: "28px",
        fontWeight: "700",
        color: "#1a237e",
        marginBottom: "5px",
    },
    statLabel: {
        fontSize: "14px",
        color: "#666",
    },
    aboutSection: {
        padding: "40px 30px",
        maxWidth: "1200px",
        margin: "0 auto",
    },
    sectionTitle: {
        fontSize: "32px",
        fontWeight: "600",
        color: "#333",
        marginBottom: "20px",
        textAlign: "center",
    },
    aboutText: {
        fontSize: "16px",
        lineHeight: "1.8",
        color: "#666",
        marginBottom: "20px",
    },
    featuresList: {
        display: "grid",
        gridTemplateColumns: "repeat(auto-fit, minmax(250px, 1fr))",
        gap: "10px",
        marginTop: "20px",
    },
    featureItem: {
        fontSize: "15px",
        color: "#333",
        padding: "10px",
        background: "#f5f5f5",
        borderRadius: "8px",
    },
    servicesSection: {
        padding: "40px 30px",
        backgroundColor: "#f5f5f5",
    },
    servicesGrid: {
        display: "grid",
        gridTemplateColumns: "repeat(auto-fit, minmax(300px, 1fr))",
        gap: "20px",
        maxWidth: "1200px",
        margin: "0 auto",
    },
    serviceCard: {
        padding: "25px",
        borderRadius: "12px",
        transition: "transform 0.2s, box-shadow 0.2s",
        "&:hover": {
            transform: "translateY(-5px)",
            boxShadow: "0 5px 20px rgba(0,0,0,0.15)",
        },
    },
    serviceIcon: {
        fontSize: "35px",
        marginBottom: "15px",
    },
    serviceTitle: {
        fontSize: "18px",
        fontWeight: "600",
        color: "#333",
        marginBottom: "10px",
    },
    serviceDesc: {
        fontSize: "14px",
        color: "#666",
        lineHeight: "1.6",
    },
    howItWorksSection: {
        padding: "40px 30px",
    },
    workflowGrid: {
        display: "grid",
        gridTemplateColumns: "repeat(auto-fit, minmax(200px, 1fr))",
        gap: "20px",
        maxWidth: "1200px",
        margin: "0 auto",
    },
    workflowCard: {
        background: "white",
        padding: "25px",
        borderRadius: "12px",
        boxShadow: "0 2px 10px rgba(0,0,0,0.08)",
        position: "relative",
    },
    workflowLink: {
        textDecoration: "none",
        color: "inherit",
        display: "block",
    },
    workflowIcon: {
        fontSize: "30px",
        marginBottom: "15px",
    },
    workflowStep: {
        fontSize: "12px",
        color: "#999",
        textTransform: "uppercase",
        marginBottom: "5px",
    },
    workflowTitle: {
        fontSize: "18px",
        fontWeight: "600",
        color: "#333",
        marginBottom: "8px",
    },
    workflowDesc: {
        fontSize: "14px",
        color: "#666",
    },
    workflowArrow: {
        position: "absolute",
        right: "-15px",
        top: "50%",
        transform: "translateY(-50%)",
        fontSize: "20px",
        color: "#999",
    },
    testimonialsSection: {
        padding: "40px 30px",
        backgroundColor: "#f5f5f5",
    },
    testimonialsGrid: {
        display: "grid",
        gridTemplateColumns: "repeat(auto-fit, minmax(300px, 1fr))",
        gap: "20px",
        maxWidth: "1200px",
        margin: "0 auto",
    },
    testimonialCard: {
        background: "white",
        padding: "25px",
        borderRadius: "12px",
        boxShadow: "0 2px 10px rgba(0,0,0,0.08)",
    },
    testimonialStars: {
        color: "#ff6f00",
        fontSize: "18px",
        marginBottom: "15px",
    },
    testimonialQuote: {
        fontSize: "15px",
        color: "#333",
        lineHeight: "1.6",
        marginBottom: "20px",
        fontStyle: "italic",
    },
    testimonialAuthor: {
        display: "flex",
        alignItems: "center",
        gap: "12px",
    },
    testimonialAvatar: {
        width: "40px",
        height: "40px",
        borderRadius: "50%",
        background: "#1a237e",
        color: "white",
        display: "flex",
        alignItems: "center",
        justifyContent: "center",
        fontSize: "18px",
        fontWeight: "600",
    },
    testimonialName: {
        fontSize: "15px",
        fontWeight: "600",
        color: "#333",
    },
    testimonialCompany: {
        fontSize: "13px",
        color: "#666",
    },
    ctaSection: {
        padding: "50px 30px",
        textAlign: "center",
        background: "linear-gradient(135deg, #ff6f00 0%, #ff8f00 100%)",
        color: "white",
    },
    ctaTitle: {
        fontSize: "28px",
        fontWeight: "600",
        marginBottom: "10px",
    },
    ctaText: {
        fontSize: "16px",
        marginBottom: "25px",
        opacity: "0.9",
    },
    ctaButton: {
        padding: "15px 40px",
        background: "white",
        color: "#ff6f00",
        border: "none",
        borderRadius: "25px",
        fontSize: "18px",
        fontWeight: "600",
        textDecoration: "none",
        display: "inline-block",
        transition: "transform 0.2s",
        "&:hover": {
            transform: "scale(1.05)",
        },
    },
    footer: {
        padding: "20px",
        textAlign: "center",
        backgroundColor: "#1a237e",
        color: "white",
    },
    footerText: {
        fontSize: "13px",
        opacity: "0.8",
    },
};

function App() {
    return (
        <BrowserRouter>
            <AuthProvider>
                <Routes>
                    {/* PUBLIC */}
                    <Route path="/login" element={<LoginPage />} />
                    <Route path="/register" element={<RegisterPage />} />
                    <Route path="/customer-addresses" element={<CustomerAddressPage scope="global" />} />
                    <Route path="/my/customer-addresses" element={<CustomerAddressPage scope="me" />} />

                    {/* PROTECTED */}
                    <Route element={<ProtectedRoute><AppLayout /></ProtectedRoute>}>
                        <Route path="/" element={<Dashboard />} />
                        <Route path="/facilities" element={<FacilitiesPage />} />
                        <Route path="/profile" element={<ProfilePage />} />
                        <Route path="/shipment-requests" element={<ShipmentRequestsPage />} />
                        <Route path="/shipments" element={<ShipmentsPage />} />
                        <Route path="/package-scans" element={<PackageScansPage />} />
                        <Route path="/tracking-events" element={<TrackingEventsPage />} />
                        <Route path="/transport-orders" element={<TransportOrdersPage />} />
                        <Route path="/delivery-attempts" element={<DeliveryAttemptsPage />} />
                        <Route path="/proof-of-deliveries" element={<ProofOfDeliveriesPage />} />
                        <Route path="/my/shipment-requests" element={<MyShipmentRequestsPage />} />
                        <Route path="/customer-addresses" element={<CustomerAddressPage scope="me" />} />
                        <Route path="/delivery-assignments" element={<DeliveryAssignmentsPage />} />
                    </Route>

                    {/* FALLBACK */}
                    <Route path="*" element={<Navigate to="/" replace />} />
                </Routes>
            </AuthProvider>
        </BrowserRouter>
    );
}

export default App;