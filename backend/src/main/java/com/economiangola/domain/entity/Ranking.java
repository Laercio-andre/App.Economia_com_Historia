// src/main/java/com/economiangola/domain/entity/Ranking.java
package com.economiangola.domain.entity;

import com.economiangola.domain.enums.TipoRanking;
import jakarta.persistence.*;
import lombok.*;

import java.time.Instant;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "rankings")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ranking extends BaseEntity {

    @Column(name = "nome", nullable = false, length = 100)
    private String nome;

    @Enumerated(EnumType.STRING)
    @Column(name = "tipo_ranking", nullable = false, length = 20)
    private TipoRanking tipoRanking;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "quiz_id")
    private Quiz quiz;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "categoria_id")
    private Categoria categoria;

    @Column(name = "periodo_inicio")
    private Instant periodoInicio;

    @Column(name = "periodo_fim")
    private Instant periodoFim;

    @OneToMany(mappedBy = "ranking", cascade = CascadeType.ALL, orphanRemoval = true)
    @OrderBy("posicao ASC")
    @Builder.Default
    private List<EntradaRanking> entradas = new ArrayList<>();
}
