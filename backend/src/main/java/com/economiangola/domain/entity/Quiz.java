// src/main/java/com/economiangola/domain/entity/Quiz.java
package com.economiangola.domain.entity;

import com.economiangola.domain.enums.Dificuldade;
import jakarta.persistence.*;
import lombok.*;

import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "quizzes")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Quiz extends SoftDeletableEntity {

    @Column(name = "titulo", nullable = false, length = 255)
    private String titulo;

    @Column(name = "slug", nullable = false, unique = true, length = 300)
    private String slug;

    @Column(name = "descricao", length = 1000)
    private String descricao;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "autor_id", nullable = false)
    private Usuario autor;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "categoria_id", nullable = false)
    private Categoria categoria;

    @Enumerated(EnumType.STRING)
    @Column(name = "dificuldade", nullable = false, length = 20)
    private Dificuldade dificuldade;

    @Column(name = "tempo_limite_seg")
    private Integer tempoLimiteSeg;

    @Column(name = "max_tentativas")
    private Integer maxTentativas;

    @Column(name = "pontuacao_maxima", nullable = false)
    @Builder.Default
    private Integer pontuacaoMaxima = 0;

    @Column(name = "activo", nullable = false)
    @Builder.Default
    private Boolean activo = true;

    @OneToMany(mappedBy = "quiz", cascade = CascadeType.ALL, orphanRemoval = true)
    @OrderBy("ordem ASC")
    @Builder.Default
    private List<Pergunta> perguntas = new ArrayList<>();
}
