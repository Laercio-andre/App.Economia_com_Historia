// src/main/java/com/economiangola/domain/entity/EntradaRanking.java
package com.economiangola.domain.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "entradas_ranking", uniqueConstraints = {
        @UniqueConstraint(columnNames = {"ranking_id", "usuario_id"})
})
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class EntradaRanking extends BaseEntity {

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ranking_id", nullable = false)
    private Ranking ranking;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "usuario_id", nullable = false)
    private Usuario usuario;

    @Column(name = "pontos", nullable = false)
    @Builder.Default
    private Integer pontos = 0;

    @Column(name = "posicao", nullable = false)
    @Builder.Default
    private Integer posicao = 0;
}
