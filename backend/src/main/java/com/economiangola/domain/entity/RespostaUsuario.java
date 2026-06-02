// src/main/java/com/economiangola/domain/entity/RespostaUsuario.java
package com.economiangola.domain.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "respostas_usuario")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RespostaUsuario extends BaseEntity {

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "resultado_quiz_id", nullable = false)
    private ResultadoQuiz resultadoQuiz;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "pergunta_id", nullable = false)
    private Pergunta pergunta;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "opcao_resposta_id", nullable = false)
    private OpcaoResposta opcaoResposta;
}
