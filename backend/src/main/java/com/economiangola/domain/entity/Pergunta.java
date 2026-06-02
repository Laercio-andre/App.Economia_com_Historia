// src/main/java/com/economiangola/domain/entity/Pergunta.java
package com.economiangola.domain.entity;

import com.economiangola.domain.enums.TipoPergunta;
import jakarta.persistence.*;
import lombok.*;

import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "perguntas")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Pergunta extends BaseEntity {

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "quiz_id", nullable = false)
    private Quiz quiz;

    @Column(name = "texto", nullable = false, length = 1000)
    private String texto;

    @Enumerated(EnumType.STRING)
    @Column(name = "tipo_pergunta", nullable = false, length = 30)
    private TipoPergunta tipoPergunta;

    @Column(name = "pontos", nullable = false)
    @Builder.Default
    private Integer pontos = 10;

    @Column(name = "ordem", nullable = false)
    @Builder.Default
    private Integer ordem = 0;

    @Column(name = "explicacao", length = 2000)
    private String explicacao;

    @OneToMany(mappedBy = "pergunta", cascade = CascadeType.ALL, orphanRemoval = true)
    @OrderBy("ordem ASC")
    @Builder.Default
    private List<OpcaoResposta> opcoes = new ArrayList<>();
}
