// src/main/java/com/economiangola/domain/entity/ResultadoQuiz.java
package com.economiangola.domain.entity;

import jakarta.persistence.*;
import lombok.*;

import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "resultados_quiz")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ResultadoQuiz extends BaseEntity {

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "usuario_id", nullable = false)
    private Usuario usuario;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "quiz_id", nullable = false)
    private Quiz quiz;

    @Column(name = "pontuacao_obtida", nullable = false)
    @Builder.Default
    private Integer pontuacaoObtida = 0;

    @Column(name = "pontuacao_maxima", nullable = false)
    @Builder.Default
    private Integer pontuacaoMaxima = 0;

    @Column(name = "tempo_gasto_seg")
    private Integer tempoGastoSeg;

    @Column(name = "tentativa_num", nullable = false)
    @Builder.Default
    private Integer tentativaNum = 1;

    @Column(name = "concluido", nullable = false)
    @Builder.Default
    private Boolean concluido = false;

    @OneToMany(mappedBy = "resultadoQuiz", cascade = CascadeType.ALL, orphanRemoval = true)
    @Builder.Default
    private List<RespostaUsuario> respostas = new ArrayList<>();
}
