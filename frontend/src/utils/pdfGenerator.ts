import { jsPDF } from 'jspdf';
import { UserProfile } from '../types';

/**
 * Generates an elegant, high-fidelity academic certificate (diploma) for the user.
 * Asserts the user's prestige points, academic ranking, and qualification level.
 */
export function generateAcademicDiploma(user: UserProfile) {
  const doc = new jsPDF({
    orientation: 'landscape',
    unit: 'mm',
    format: 'a4'
  });

  // Page dimensions for A4 Landscape: 297mm x 210mm
  const width = 297;
  const height = 210;

  // 1. Draw elegant Bordeaux Wine Border background margin
  doc.setFillColor(123, 26, 46); // RGB #7B1A2E
  doc.rect(0, 0, width, height, 'F');

  // Offset-outer white elegant card sheet
  doc.setFillColor(254, 252, 246); // Soft luxury off-white #FEFCF6
  doc.rect(8, 8, width - 16, height - 16, 'F');

  // Double gold thin borders
  doc.setDrawColor(212, 175, 55); // Premium Gold RGB #D4AF37
  doc.setLineWidth(1.2);
  doc.rect(12, 12, width - 24, height - 24, 'S');
  
  doc.setLineWidth(0.4);
  doc.rect(14, 14, width - 28, height - 28, 'S');

  // Inner decorative corner embellishments (gold lines)
  const d = 22;
  // Top-left
  doc.line(14, d, d, 14);
  // Top-right
  doc.line(width - 14, d, width - d, 14);
  // Bottom-left
  doc.line(14, height - d, d, height - 14);
  // Bottom-right
  doc.line(width - 14, height - d, width - d, height - 14);

  // 2. Institutional Title
  doc.setFont('times', 'bold');
  doc.setFontSize(22);
  doc.setTextColor(123, 26, 46); // Bordeaux
  doc.text('INSTITUTO SUPERIOR DE ESTUDO MONETÁRIO DE LUANDA', width / 2, 34, { align: 'center' });
  
  doc.setFont('times', 'italic');
  doc.setFontSize(10);
  doc.setTextColor(150, 110, 50); // Muted gold/brown
  doc.text('Gabinete de Qualificação Científica e Consolidação Fiduciária de Angola', width / 2, 40, { align: 'center' });

  // Thin separator gold line
  doc.setLineWidth(0.5);
  doc.line(width / 2 - 45, 45, width / 2 + 45, 45);

  // Decorative Golden Seal / Vignette Icon outline
  doc.setFillColor(245, 230, 200);
  doc.ellipse(width / 2, 60, 8, 8, 'F');
  doc.setFont('times', 'bold');
  doc.setFontSize(12);
  doc.setTextColor(123, 26, 46);
  doc.text('A', width / 2, 62, { align: 'center' });

  // 3. Central Certificate Text Statement
  doc.setFont('times', 'normal');
  doc.setFontSize(14);
  doc.setTextColor(40, 40, 40);
  doc.text('Certifica-se solenemente que o(a) ilustre especialista e investidor(a)', width / 2, 80, { align: 'center' });

  // User Name in Large Times Bold
  doc.setFont('times', 'bold');
  doc.setFontSize(26);
  doc.setTextColor(123, 26, 46);
  doc.text(user.name.toUpperCase(), width / 2, 95, { align: 'center' });

  // Statement main paragraph
  doc.setFont('times', 'normal');
  doc.setFontSize(12);
  doc.setTextColor(70, 70, 70);
  const statement = `Cumpre rigorosamente todos os preceitos de sabedoria fiscal, análise conjuntural e história económica.
Demonstrou competência soberana ao acumular ${user.points} pontos de prestígio e atingir a posição oficial de `;
  doc.text(statement, width / 2, 108, { align: 'center', maxWidth: 210 });

  // User Role (Red Accent font)
  doc.setFont('times', 'bold');
  doc.setFontSize(15);
  doc.setTextColor(123, 26, 46);
  doc.text(user.role.toUpperCase(), width / 2, 126, { align: 'center' });

  // Double lines for statistics panel
  doc.setDrawColor(220, 220, 220);
  doc.setLineWidth(0.3);
  doc.line(40, 138, width - 40, 138);
  doc.line(40, 153, width - 40, 153);

  // Statistics detailed text inside certificate
  doc.setFont('helvetica', 'normal');
  doc.setFontSize(9);
  doc.setTextColor(90, 90, 90);
  
  doc.text('PONTUAÇÃO ACUMULADA', 55, 143, { align: 'center' });
  doc.setFont('helvetica', 'bold');
  doc.setFontSize(11);
  doc.setTextColor(123, 26, 46);
  doc.text(`${user.points} PTS`, 55, 149, { align: 'center' });

  doc.setFont('helvetica', 'normal');
  doc.setFontSize(9);
  doc.setTextColor(90, 90, 90);
  doc.text('RANKING DE ELITE', width / 2, 143, { align: 'center' });
  doc.setFont('helvetica', 'bold');
  doc.setFontSize(11);
  doc.setTextColor(40, 40, 40);
  doc.text(`#${user.globalRanking}º LUGAR`, width / 2, 149, { align: 'center' });

  doc.setFont('helvetica', 'normal');
  doc.setFontSize(9);
  doc.setTextColor(90, 90, 90);
  doc.text('AVALIAÇÕES DE QUIZZES', width - 55, 143, { align: 'center' });
  doc.setFont('helvetica', 'bold');
  doc.setFontSize(11);
  doc.setTextColor(123, 26, 46);
  doc.text(`${user.quizPercentage}% ACERTO`, width - 55, 149, { align: 'center' });

  // 4. Footer & Signatures
  doc.setFont('times', 'italic');
  doc.setFontSize(9.5);
  doc.setTextColor(110, 110, 110);
  
  // Signature Lines
  doc.line(45, 180, 115, 180);
  doc.text('Conselho Geral Superior', 80, 185, { align: 'center' });
  doc.setFont('helvetica', 'bold', '9px');
  doc.text('LUANDA, REPUBLICA DE ANGOLA', 80, 189, { align: 'center' });

  doc.line(width - 115, 180, width - 45, 180);
  doc.setFont('times', 'italic');
  doc.text('Chanceler de Registros Fiduciários', width - 80, 185, { align: 'center' });
  
  // Date timestamp
  const dateStr = new Date().toLocaleDateString('pt-PT', { day: 'numeric', month: 'long', year: 'numeric' });
  doc.setFont('times', 'normal');
  doc.setFontSize(8.5);
  doc.setTextColor(140, 140, 140);
  doc.text(`Emitido digitalmente em Luanda a ${dateStr}`, width / 2, 192, { align: 'center' });

  // Save PDF
  doc.save(`Diploma_Investidor_${user.name.replace(/\s+/g, '_')}.pdf`);
}

/**
 * Generates and downloads a beautifully set out PDF for a research paper/article analysis.
 */
export function generateArticlePDF(article: {
  title: string;
  category: string;
  date: string;
  author: string;
  authorTitle: string;
  content: string[];
}) {
  const doc = new jsPDF({
    orientation: 'portrait',
    unit: 'mm',
    format: 'a4'
  });

  const width = 210;
  
  // Elegant border design (A4 Portrait)
  doc.setDrawColor(123, 26, 46); // Bordeaux
  doc.setLineWidth(0.8);
  doc.rect(10, 10, width - 20, 277);

  doc.setDrawColor(212, 175, 55); // Gold
  doc.setLineWidth(0.2);
  doc.rect(11.5, 11.5, width - 23, 274);

  // Header Banner
  doc.setFillColor(123, 26, 46);
  doc.rect(15, 15, width - 30, 22, 'F');
  
  doc.setFont('helvetica', 'bold');
  doc.setFillColor(212, 175, 55);
  doc.rect(15, 37, width - 30, 1.2, 'F');

  doc.setFont('times', 'bold');
  doc.setFontSize(12);
  doc.setTextColor(255, 255, 255);
  doc.text('BIBLIOTECA DE ECONOMIA & CONJUNTURA DE LUANDA', width / 2, 23, { align: 'center' });
  doc.setFontSize(8);
  doc.setFont('times', 'italic');
  doc.setTextColor(220, 200, 150);
  doc.text('Análise Científica de Mercado, História Fiduciária e Reservas e Commodities de Angola', width / 2, 29, { align: 'center' });

  // Article Metadata Box
  doc.setFillColor(248, 245, 238); // Cream container
  doc.rect(15, 43, width - 30, 24, 'F');
  doc.setDrawColor(220, 215, 200);
  doc.setLineWidth(0.3);
  doc.rect(15, 43, width - 30, 24, 'S');

  doc.setFont('helvetica', 'bold');
  doc.setFontSize(8.5);
  doc.setTextColor(123, 26, 46);
  doc.text(`CATEGRORIA ACADÉMICA: ${article.category}`, 20, 49);

  doc.setTextColor(100, 100, 100);
  doc.setFont('helvetica', 'normal');
  doc.text(`Data de Registo: ${article.date}`, 20, 55);
  doc.text(`Autor da Tese: ${article.author}`, 20, 61);
  doc.setFont('helvetica', 'italic');
  doc.setFontSize(8);
  doc.text(`${article.authorTitle}`, 20, 65);

  // Article Title
  doc.setFont('times', 'bold');
  doc.setFontSize(17);
  doc.setTextColor(15, 15, 15);
  const splitTitle = doc.splitTextToSize(article.title, width - 40);
  doc.text(splitTitle, 20, 78);

  // Separation Line
  doc.setLineWidth(0.4);
  doc.setDrawColor(123, 26, 46);
  doc.line(20, 93, width - 20, 93);

  // Immersive text paragraphs
  doc.setFont('times', 'normal');
  doc.setFontSize(11);
  doc.setTextColor(45, 45, 45);

  let currentY = 101;
  const bottomMargin = 265;

  article.content.forEach((paragraph, idx) => {
    const textLines = doc.splitTextToSize(paragraph, width - 40);
    const heightNeeded = textLines.length * 5.2 + 8; // Calculate height dynamically

    if (currentY + heightNeeded > bottomMargin) {
      // Add page brake dynamically
      doc.addPage();
      
      // Draw border on new page
      doc.setDrawColor(123, 26, 46);
      doc.setLineWidth(0.8);
      doc.rect(10, 10, width - 20, 277);
      
      doc.setDrawColor(212, 175, 55);
      doc.setLineWidth(0.2);
      doc.rect(11.5, 11.5, width - 23, 274);

      currentY = 25; // Reset high margin
    }

    // Paragraph indicator
    doc.setFillColor(123, 26, 46);
    doc.rect(20, currentY - 1, 1.5, 4, 'F');

    doc.text(textLines, 24, currentY + 2);
    currentY += heightNeeded;
  });

  // Footer official stamp statement
  if (currentY + 25 > bottomMargin) {
    doc.addPage();
    doc.setDrawColor(123, 26, 46);
    doc.setLineWidth(0.8);
    doc.rect(10, 10, width - 20, 277);
    currentY = 25;
  }

  doc.setLineWidth(0.3);
  doc.setDrawColor(212, 175, 55);
  doc.line(30, currentY + 5, width - 30, currentY + 5);

  doc.setFont('times', 'italic');
  doc.setFontSize(8.5);
  doc.setTextColor(110, 110, 110);
  doc.text('Colecção restrita científica outorgada pela Biblioteca Superior de Economia de Luanda.', width / 2, currentY + 11, { align: 'center' });
  doc.text('Impresso eletronicamente sob autorização. Proibida reprodução comercial não-licenciada.', width / 2, currentY + 15, { align: 'center' });

  doc.save(`Artigo_Economico_${article.title.substring(0, 25).replace(/\s+/g, '_')}.pdf`);
}
